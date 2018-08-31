-- LOADING SCREEN --
love.graphics.clear()
love.graphics.setBackgroundColor(255,255,255)
love.graphics.print("Loading...", 10, 10)
love.graphics.present()
--

local screens = require('screens._all')
local screenManager = nil

function love.load()
	screenManager = require('lib.ScreenManager')(screens, 'home')
end

function love.draw()
	screenManager:draw()
end

function love.update(dt)
	screenManager:update(dt)
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	else
		screenManager:keypressed(k)
	end
end 