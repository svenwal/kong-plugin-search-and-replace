# About
`````search-and-replace````` is a [Kong](https://konghq.com) plugin which replaces in the response (request will be added in a later release) any string with another string.

## Configuration parameters
|FORM PARAMETER|DEFAULT|DESCRIPTION|
|:----|:------:|------:|
|config.response_search_string||The search string to be found in the payload (see also notes on search string in known limitations)|
|config.response_replace_string||The replacement for the above string|

## Known limitations

* TBD: As of release 0.1 it only works on the response
* TBD: GZip encoded payloads are not support
* TBD: It will run on any payload size so be careful as the content is cached in memory (limitation parameter to be added in later release)
* TBD: The search string is a Lua pattern matching string so be careful and quote special characters `( ) % . + - * [ ? ^ $` with a prefixed `%` (see also <https://riptutorial.com/lua/example/20315/lua-pattern-matching>). Will add an option to automatically quote them if regexp is not wanted in a later release
* TBD: only one replacement is done. This will be extended by providing arrays for search and replace config paramters instead
* The response will not provide a `content-length` header anymore due to the plugin phases within Kong

## Examples

### Before enabling plugin:

`````
> http :8000/searchAndReplace

HTTP/1.1 200 OK
(...)

Foo

https://www.google.de

bar
`````

### Response before enabling the plugin

Note the quoted `.` in the url!

````
> http -f :8001/services/<SERVICE>/plugins name=search-and-replace config.response_search_string = "https://www%.google%.de" config.response_replace_string = "https://duckduckgo.com"

HTTP/1.1 201 Created
(...)

{
    "config": {
        "response_search_string": "https://www%.google%.de",
        "response_replace_string": "https://duckduckgo.com",
    },
    "created_at": 1554887400000,
    "enabled": true,
    "id": "1a659088-2e38-4a9f-bfef-f84400c86f5a",
    "name": "search-and-replace",
    "service_id": "f42acc5b-4e85-4ec2-8638-c7dbdd84b8a9"
}
````

### Response after enabling plugin

`````
> http :8000/searchAndReplace

HTTP/1.1 200 OK
(...)

Foo

https://duckduckgo.com

bar
`````

