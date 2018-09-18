local class = require('lib.class')
local fonts = require('assets.fonts._all')

local Offline = class {
	activeScreen = nil -- screen manager
}

function Offline:init()
	self.offlineLogo = love.graphics.newImage("assets/images/offline.png")
	self.offlineText = love.graphics.newText(fonts.SegoeUI_bold_huge, "Offline")
end

function Offline:draw()
	love.graphics.setBackgroundColor(255, 255, 255)
	
	local w, h = love.window.getMode()
	local middleOffset = 20
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.offlineLogo, w / 2 - self.offlineLogo:getWidth() / 2, h / 2 - self.offlineLogo:getHeight() / 2 - middleOffset)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(self.offlineText,  w / 2 - self.offlineText:getWidth() / 2, h / 2 - self.offlineText:getHeight() / 2 + middleOffset)
end

function Offline:update()
end

function Offline:keypressed(k)
end

return Offline