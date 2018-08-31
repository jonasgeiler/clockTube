local class = require('lib.class')

local Offline = class{}

function Offline:init() end

function Offline:draw()
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.print("Offline.", 10, 10)
end

function Offline:update()
	
end

function Offline:keypressed(k)
	
end

return Offline