package = "kong-oauth-keycloak"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      access = "src/access.lua",
      handler = "src/handler.lua",
      schema = "src/schema.lua"
   }
}
