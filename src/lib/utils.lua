local http = require('socket.http')

local utils = {}

function utils.newImageFromURL(url, name)
	local rawImageData = http.request(url)
	local fileData = love.filesystem.newFileData(rawImageData, name, 'file')
	local imageData = love.image.newImageData(fileData)
	return love.graphics.newImage(imageData)
end

function utils.drawDashedLine(x1, y1, x2, y2, min, max)
	min = min or 0
	max = max or 8

	love.graphics.setPointSize(2)

	local x, y = x2 - x1, y2 - y1
	local len = math.sqrt(x ^ 2 + y ^ 2)
	local stepx, stepy = x / len, y / len
	x = x1
	y = y1

	for i = 1, len do
		local lastDigit = tonumber(tostring(i):sub(-1))
		if lastDigit > min and lastDigit < max then
			love.graphics.points(x, y)
		end

		x = x + stepx
		y = y + stepy
	end
end

return utils