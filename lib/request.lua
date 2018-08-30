-- SIMPLE YOUTUBE API WRAPPER --
--       made by Skayo        --

local http = require('socket.http')
--local https = require('ssl.https')
local json = require('lib.json')

return function(...)
	local args = {...}
	local reqbody = args[3] or ''

	local respbody = {}

	http.request {
		method = args[1],
		url = args[2],
		source = ltn12.source.string(reqbody),
		headers = {
			['Content-Type'] = 'application/x-www-form-urlencoded',
			['Content-Length'] = #reqbody
		},
		sink = ltn12.sink.table(respbody)
	}

	return table.concat(respbody)
end