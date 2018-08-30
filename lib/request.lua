-- SIMPLE YOUTUBE API WRAPPER --
--       made by Skayo        --

json = require('json')()

local request = {}

-- HTTP GET request
function request.get(url)
	local requestHandler = io.popen('curl ' .. url, 'r')
	return requestHandler:read('*l')
end

return request