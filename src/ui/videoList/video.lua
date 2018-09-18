local class = require('lib.class')
local formatNumber = require('lib.formatNumber')
local fonts = require('assets.fonts._all')
local utf8 = require('lib.utf8')
local utils = require('lib.utils')

local Video = class {
	specs = {
		width = 300,
		height = 90,
		text_width = 175, -- max width of the title and username. Adds newline if exceeds

		border_padding = 3 -- space between video box and selected-border
	}
}

function Video:init(data)
	-- Thumbnail
	self.thumbnail = utils.newImageFromURL(data.thumbnail, 'thumbnail.png')

	-- Views count
	if data.views then -- if video return no views count
		self.views = love.graphics.newText(fonts.SegoeUI_light, formatNumber(data.views, 0) .. ' Views')
	else
		self.views = love.graphics.newText(fonts.SegoeUI_light, '')
	end
	
	-- Username
	local _, wrappedUsername = fonts.SegoeUI_light:getWrap(data.username, self.specs.text_width)
	
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
		utils.drawDashedLine(x - self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding)
		utils.drawDashedLine(x - self.specs.border_padding - 1, y - self.specs.border_padding, x - self.specs.border_padding - 1, y + self.specs.height + self.specs.border_padding)
		utils.drawDashedLine(x - self.specs.border_padding - 1, y + self.specs.height + self.specs.border_padding + 1, x + self.specs.width + self.specs.border_padding + 1, y + self.specs.height + self.specs.border_padding + 1)
		utils.drawDashedLine(x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y + self.specs.height + self.specs.border_padding)
	end
end

return Video