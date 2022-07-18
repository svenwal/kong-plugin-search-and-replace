package = "kong-plugin-search-and-repalce"
local pluginName = package:match("^kong%-plugin%-(.+)$")
version = "0.2.0-1"
supported_platforms = {"linux", "macosx"}
source = {
   url = "git+https://github.com/svenwal/kong-plugin-search-and-replace.git"
}
description = {
   summary = "A Kong plugin which replaces contents in the body of the request and response",
   detailed = [[
## Configuration parameters
  |FORM PARAMETER|DEFAULT|DESCRIPTION|
  |:----|:------:|------:|
  |config.request_search_string||The search string to be found in the payload (see also notes on search string in known limitations)|
  |config.request_replace_string||The replacement for the above string|,
  |config.response_search_string||The search string to be found in the payload (see also notes on search string in known limitations)|
  |config.response_replace_string||The replacement for the above string|,
   homepage = "https://github.com/svenwal/kong-plugin-search-and-replace",
   license = "BSD 2-Clause License"
}

dependencies = {}

build = {
  type = "builtin",
  modules = {
    -- TODO: add any additional files that the plugin consists of
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
