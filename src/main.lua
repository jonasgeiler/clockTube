-- LOADING SCREEN --
love.graphics.clear()
love.graphics.setBackgroundColor(255, 255, 255)
love.graphics.print("Loading...", 10, 10)
love.graphics.present()
--

-- this fixes compatibility for LÖVE 0.10.2 colors (0-255 instead of 0-1)
require('lib.compat')
--

local screenManager

function connected()
	local requestHandler = io.popen('curl --silent "http://example.com"', 'r')
	local response = requestHandler:read('*all')
	
	return (#response > 0)
end

function love.load()
	local screens = {}
	local initialScreen = 'home'

	if not connected() then
		screens = {
			offline = require('screens.offline')()
		}
		initialScreen = 'offline'
	else
		screens = require('screens._all')
	end

	screenManager = require('lib.ScreenManager')(screens, initialScreen)
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