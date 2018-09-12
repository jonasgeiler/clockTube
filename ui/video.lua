local class = require('lib.class')
local formatNumber = require('lib.formatNumber')
local fonts = require('assets.fonts._all')
local http = require('socket.http')
local utf8 = require('lib.utf8')

local Video = class {
	username = '',
	views = 0,
	title = '',
	thumbnail = '',
	url = '',
	specs = {
		width = 300,
		height = 90,
		text_width = 175, -- max width of the title and username. Adds newline if exceeds

		border_padding = 3 -- space between video box and selected-border
	}
}

function newImageFromURL(url, name)
	local rawThumbnailData = http.request(url)
	local fileData = love.filesystem.newFileData(rawThumbnailData, name, 'file')
	local imageData = love.image.newImageData(fileData)
	return love.graphics.newImage(imageData)
end

function Video:init(data)
	-- Thumbnail
	self.thumbnail = newImageFromURL(data.thumbnail, 'thumbnail.png')

	-- Views count
	if data.views then -- if video return no views count
		self.views = love.graphics.newText(fonts.SegoeUI_light, formatNumber(data.views, 0) .. ' Views')
	else
		self.views = love.graphics.newText(fonts.SegoeUI_light, '')
	end
	
	-- Username
	local _, wrappedUsername = fonts.SegoeUI_bold:getWrap(data.username, self.specs.text_width)
	
	local newUsername = wrappedUsername[1]
	if #wrappedUsername > 1 then -- if the username got wrapped ...
		newUsername = newUsername:sub(0, #newUsername - 3) .. "..." -- add 3 dots (...)
	end
	self.username = love.graphics.newText(fonts.SegoeUI_light, newUsername)

	-- Title
	data.title = utf8.strip(data.title)
	local _, wrappedTitle = fonts.SegoeUI_bold:getWrap(data.title, self.specs.text_width)
	
	if #wrappedTitle >= 3 then -- if the title got wrapped 3 times
		wrappedTitle[2] = wrappedTitle[2]:sub(0, #wrappedTitle[2] - 3) .. "..." -- add 3 dots (...)
	end
	
	local newTitle = ""
	for lineNum,line in pairs(wrappedTitle) do
		if lineNum <= 2 then
			newTitle = newTitle .. line .. "\n"
		end
	end
	
	self.title = love.graphics.newText(fonts.SegoeUI_bold, newTitle)
end

function drawDashedLine(x1, y1, x2, y2, min, max)
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

function Video:draw(x, y, selected)
	-- Thumbnail
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.thumbnail, x, y)

	-- Title
	love.graphics.setColor(20, 20, 20)
	love.graphics.draw(self.title, x + 125, y + 5)
	love.graphics.draw(self.username, x + 127, y + 40)
	love.graphics.draw(self.views, x + 127, y + 55)

	-- Selection Border
	if selected then
		love.graphics.setColor(51, 166, 255)
		drawDashedLine(x - self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding)
		drawDashedLine(x - self.specs.border_padding - 1, y - self.specs.border_padding, x - self.specs.border_padding - 1, y + self.specs.height + self.specs.border_padding)
		drawDashedLine(x - self.specs.border_padding - 1, y + self.specs.height + self.specs.border_padding + 1, x + self.specs.width + self.specs.border_padding + 1, y + self.specs.height + self.specs.border_padding + 1)
		drawDashedLine(x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y + self.specs.height + self.specs.border_padding)
	end
end

return Video