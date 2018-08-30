love.graphics.clear()
love.graphics.setBackgroundColor(255,255,255)
love.graphics.print("Loading...", 10, 10)
love.graphics.present()

local states = require('states._all')

local currState = ''

function love.load()
	currState = 'home'
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