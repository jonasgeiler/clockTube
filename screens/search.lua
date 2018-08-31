local class = require('lib.class')

local Search = class{
	activeScreen = ''
}

function Search:init() end

function Search:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.print("Search.", 10, 10)
end

function Search:update()
	
end

function Search:keypressed(k)
	if k == 'j' then
		self.activeScreen = 'home'
	end
end

return Search