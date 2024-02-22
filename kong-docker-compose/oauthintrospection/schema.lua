return {
    name = "oauthintrospection",
    fields = {
      { config = {
          type = "record",
          fields = {
            { introspection_endpoint = { type = "string", required = true,default = "http://localhost/realm",}, },
            { client_id  = { type = "string", required = true,default = "client_id",}, },
            { client_secret  = { type = "string", required = true,default = "secret",}, },
            { token_header = { type = "string",required = true, default = "Authorization",}, },
            { https_verify = { type = "boolean",required = true, default = false, }, },
          },
    }, },
  }
}