-- Custom Plugin Token Instrospect with Authorization Server
local http = require "resty.http"
local cjson = require "cjson.safe"
local pl_stringx = require "pl.stringx"
local encode_base64 = ngx.encode_base64

local OAuthIntrospection = {}

OAuthIntrospection.PRIORITY = 1410
OAuthIntrospection.VERSION = "1.0.0"

-- Function Error Response
local function error_response(status, error_type, message, error_detail)
  local json_message = '{"code":' .. status .. ',"errorType":"'.. error_type ..'", "description":"' .. message .. '", "errorDetail":[{"code":"ER0001","description":"' .. error_detail ..'"}]}'
  return kong.response.exit(status, json_message, {
    ["Content-Type"] = "application/json"
  })
end

-- Function Get Value Access Token From header
-- Function remove Bearer
local function get_acces_token(header_name)
  local request_header = kong.request.get_header(header_name)
  kong.log.err(request_header)
  if not request_header then
    kong.log.err(err," ErrorMessageAuthorization header not present or access token invalid.")
    return error_response(401,"Technical","Unauthenticated","Request is missing, required Authorization or Access Token invalid.")
  end
  local token = pl_stringx.replace(request_header, "Bearer ", "", 1)
  return token
end

-- Implement Logic
function OAuthIntrospection:access(conf)

  local access_token = get_acces_token(conf.token_header)
  kong.log.err("Access Token: ", access_token)
  local request_method = "POST"
  local uri = conf.introspection_endpoint

  -- Send Request Token Instrospect
  local authorization = 'Basic '..encode_base64(conf.client_id..':'..conf.client_secret)
  local client = http.new()
  local res, err = client:request_uri(uri, {
    method = request_method,
    body = "token=" .. access_token,
    headers = {["Authorization"]= authorization, ["Content-Type"] = "application/x-www-form-urlencoded"},
    ssl_verify = conf.https_verify,
  })
  if not res then
    kong.log.err(err)
    return error_response(501,"Technical","Service Unvailable","An unexpected error occurred.")
  end
  local data = cjson.decode(res.body)
  kong.log.err("Response Authorization Server Body: ",res.body)
  kong.log.err("Response Authorization Server Status: ",res.status)
  kong.log.err("Response Authorization Server Headers: ",res.headers)
  kong.log.err("Error Authorization Server: ",err)

    -- Validate Not Response
  if res.status == 404 then
    kong.log.err(err, " KeyCloak Realm does not exist, validate exist Realm in Keycloak authorization server.")
    return error_response(501,"Technical","Service Unvailable","An unexpected error occurred.")
  end
  if data["error"] == "invalid_request"  then
    kong.log.err(err, " KeyCloak invalid_request, validate client_id or client_secret used for instrospect access token.")
    return error_response(401,"Technical","UnAuthorized","The resource owner or authorization server denied the request.")
  end
  -- Validate Active Access Token
  
  if data["active"] ~= true then
    return error_response(401,"Technical","UnAuthorized","The resource owner or authorization server denied the request.")
  end 
end

return OAuthIntrospection