local class = require('lib.class')

local Offline = class {
	activeScreen = nil -- screen manager
}

function Offline:init() end

function Offline:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Offline.", 10, 10)
end

function Offline:update()
end

function Offline:keypressed(k)
end

return Offline