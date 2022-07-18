package = "kong-plugin-search-and-repalce"
local pluginName = package:match("^kong%-plugin%-(.+)$")
version = "0.3.0-1"
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
  |config.request_replace_string||The replacement for the above string|
  |config.request_maximum_payload_size||Maximum payload size being processed - note also: Kong wide maximum is set with parameter `client_body_buffer_size`|
  |config.request_maximum_payload_no_content_length_forward_unprocessed|false|Should the request handled if no `content-length` header is sent. Will return a `41r13` if set to false|
  |config.request_maximum_payload_exceeded_forward_unprocessed|true|Shall the unaltered body be forwarded if payload size is exceeded. Note: if you are using this plugin to hide sensitve data make sure to set this to `false` as otherwise the unprocessed data gets forwarded|
  |config.response_search_string||The search string to be found in the payload (see also notes on search string in known limitations)|
  |config.response_replace_string||The replacement for the above string|
  |config.response_maximum_payload_size||Maximum payload size being processed - note also: Kong wide maximum is set with parameter `client_body_buffer_size`|
  |config.response_maximum_payload_no_content_length_forward_unprocessed|false|Should the request handled if no `content-length` header is sent. Will return a `41r13` if set to false|
  |config.response_maximum_payload_exceeded_forward_unprocessed|true|Shall the unaltered body be forwarded if payload size is exceeded. Note: if you are using this plugin to hide sensitve data make sure to set this to `false` as otherwise the unprocessed data gets forwarded|
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
