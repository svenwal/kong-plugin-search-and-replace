local plugin = {
  PRIORITY = 1000, 
  VERSION = "0.1", 
}

function plugin:access(plugin_conf)
  if plugin_conf.request_search_string then
    if plugin_conf.request_maximum_payload_size then
      local content_length = kong.request.get_header("Content-Length")
      if not content_length then
        kong.log.warn("Request size limitation set but got no content length header")
        if not plugin_conf.request_maximum_payload_no_content_length_forward_unprocessed then
          kong.log.debug("Forwading request as is")
          return
        else
          kong.log.debug("Aborting forwarding the call")
          return kong.response.exit(411, "Length Required")
        end 
      end
      if tonumber(content_length) > plugin_conf.request_maximum_payload_size then
        kong.log.info("Request size limitation set but payload size of " .. content_length .. " is bigger than the set maximum of " .. plugin_conf.request_maximum_payload_size)
        if not plugin_conf.request_maximum_payload_exceeded_forward_unprocessed then
          kong.log.debug("Forwading request as is")
          return
        else
          kong.log.debug("Aborting forwarding the call")
          return kong.response.exit(413, "Payload to large")
        end 
      end
    end
    local body = kong.request.get_raw_body()
    if body then
      kong.log.debug("Request search string: " .. plugin_conf.request_search_string)
      local replace_string = plugin_conf.request_replace_string
      if not replace_string then
        replace_string = ""
      end
      kong.log.debug("Request replace string: " .. replace_string)
	      
      local replaced_body = body:gsub(plugin_conf.request_search_string, replace_string)
      kong.service.request.set_raw_body(replaced_body)
    end
  end
end 


function plugin:header_filter(plugin_conf)
  if plugin_conf.response_search_string then
    if plugin_conf.response_maximum_payload_size then
      local content_length = kong.response.get_header("Content-Length")
      if not content_length then
        kong.log.warn("Response size limitation set but got no content length header")
        if not plugin_conf.response_maximum_payload_no_content_length_forward_unprocessed then
        kong.log.debug("Will process the body anyway")
        else
          kong.log.debug("Aborting forwarding the call")
          return kong.response.exit(500, "Service Unavailable")
        end
      end 
      if tonumber(content_length) > plugin_conf.response_maximum_payload_size then
        kong.log.info("Response size limitation set but payload size of " .. content_length .. " is bigger than the set maximum of " .. plugin_conf.response_maximum_payload_size)
        if not plugin_conf.response_maximum_payload_exceeded_forward_unprocessed then
          kong.log.debug("Forwading response as is")
          kong.ctx.plugin.dont_process = true
          return
        else
          kong.log.debug("Aborting forwarding the call")
          return kong.response.exit(500, "Payload to large")
        end 
      end
    end
    kong.response.clear_header("Content-Length")
  end
end


function plugin:body_filter(plugin_conf)
  if kong.ctx.plugin.dont_process then
    return
  end
  if plugin_conf.response_search_string then
    local body = kong.response.get_raw_body()
    if body then
      kong.log.debug("Response search string: " .. plugin_conf.response_search_string)
      local replace_string = plugin_conf.response_replace_string
      if not replace_string then
        replace_string = ""
      end
      kong.log.debug("Response replace string: " .. replace_string)
	      
      local replaced_body = body:gsub(plugin_conf.response_search_string, replace_string)
      kong.response.set_raw_body(replaced_body)
    end
  end
end 

return plugin
