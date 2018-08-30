-- SIMPLE YOUTUBE API WRAPPER --
--       made by Skayo        --

local http = require('socket.http')
--local https = require('ssl.https')
local json = assert(loadfile "lib/json.lua")()

function encodeURI(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
   end
   return str
end

return function(url, params, decodeJSON)
	if params then -- if parameters where passed
		local paramsString = ''
		
		for key,value in pairs(params) do
			paramsString = paramsString .. key .. '=' .. tostring(value) .. '&'
		end
		
		url = url .. '?' .. paramsString
	end

print(url)
	local requestHandler = io.popen('curl --silent "' .. url ..'"', 'r')
	local response = requestHandler:read('*all')

	if decodeJSON then
		return json:decode(response)
	end	
	
	return response
end