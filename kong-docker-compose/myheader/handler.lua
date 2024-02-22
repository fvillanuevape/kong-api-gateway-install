local MyHeader = {}
local set_header = kong.service.request.set_header
local get_header = kong.request.get_header
local get_headers = kong.request.get_headers
MyHeader.PRIORITY = 1000
MyHeader.VERSION = "1.0.0"


function MyHeader:access(conf)
  set_header("X-Consumer-Custom-ID","bga-demo")
  get_headers()
  kong.log.err("MyHeader: ", get_headers())
end
function MyHeader:header_filter(conf)
  -- do custom logic here
  local my_header=get_header("X-Consumer-Custom-ID")
  kong.log.err("MyHeader: ", my_header)
  kong.response.set_header("myheader", my_header)
end

return MyHeader