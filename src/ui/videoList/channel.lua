local class = require('lib.class')
local formatNumber = require('lib.formatNumber')
local fonts = require('assets.fonts._all')
local utf8 = require('lib.utf8')
local utils = require('lib.utils')

local Channel = class {
	specs = {
		width = 300,
		height = 90,
		text_width = 175, -- max width of the title and username. Adds newline if exceeds
		avatar_radius = 88/2,

		border_padding = 3 -- space between Channel box and selected-border
	}
}

function Channel:init(data)
	-- Thumbnail
	self.avatar = utils.newImageFromURL(data.avatar, 'avatar.png')
	
	-- Username
	local _, wrappedUsername = fonts.SegoeUI_bold_medium:getWrap(data.username, self.specs.text_width)
	
	local newUsername = wrappedUsername[1]
	if #wrappedUsername > 1 then -- if the username got wrapped ...
		newUsername = newUsername:sub(0, #newUsername - 3) .. "..." -- add 3 dots (...)
	end
	self.username = love.graphics.newText(fonts.SegoeUI_bold_medium, newUsername)

	-- Description
	data.description = utf8.strip(data.description)
	local _, wrappedDescription = fonts.SegoeUI_light:getWrap(data.description, self.specs.text_width)
	
	if #wrappedDescription >= 5 then -- if the title got wrapped 3 times
		wrappedDescription[4] = wrappedDescription[4]:sub(0, #wrappedDescription[4] - 3) .. "..." -- add 3 dots (...)
	end
	
	local newDescription = ""
	for lineNum,line in pairs(wrappedDescription) do
		if lineNum <= 4 then
			newDescription = newDescription .. line .. "\n"
		end
	end
	
	self.description = love.graphics.newText(fonts.SegoeUI_light, newDescription)
end

function Channel:draw(x, y, selected)
	-- Thumbnail
	love.graphics.stencil(function()
		love.graphics.circle("fill", x + self.specs.avatar_radius, y + 1 + self.specs.avatar_radius, self.specs.avatar_radius)
	end, "replace", 1)

	love.graphics.setStencilTest("greater", 0)
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.avatar, x, y + 1)

	love.graphics.setStencilTest()

	-- Username and Description
	love.graphics.setColor(20, 20, 20)
	love.graphics.draw(self.username, x + 100, y + 5)
	love.graphics.draw(self.description, x + 100, y + 25)

	-- Selection Border
	if selected then
		love.graphics.setColor(51, 166, 255)
		utils.drawDashedLine(x - self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding)
		utils.drawDashedLine(x - self.specs.border_padding - 1, y - self.specs.border_padding, x - self.specs.border_padding - 1, y + self.specs.height + self.specs.border_padding)
		utils.drawDashedLine(x - self.specs.border_padding - 1, y + self.specs.height + self.specs.border_padding + 1, x + self.specs.width + self.specs.border_padding + 1, y + self.specs.height + self.specs.border_padding + 1)
		utils.drawDashedLine(x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y + self.specs.height + self.specs.border_padding)
	end
end

return Channel