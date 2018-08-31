-- LOADING SCREEN --
love.graphics.clear()
love.graphics.setBackgroundColor(255,255,255)
love.graphics.print("Loading...", 10, 10)
love.graphics.present()
--

local states = require('states._all')

local currState = ''

function isConnected()
	local pingHandler = io.popen('ping -q -w1 -c1 google.com &>/dev/null && echo online || echo offline', 'r')
	local status = pingHandler:read('*all')
	
	if status == 'offline' then
		return false
	end
	
	return true
end

function love.load()
	if isConnected() then
		currState = 'home'
	else
		currState = 'offline'
	end
end

function love.draw()
	love.graphics.setWireframe(false)
	states[currState]:draw()
end

function love.update()
	states[currState]:update()
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	else
		states[currState]:keypressed(k)
	end
end