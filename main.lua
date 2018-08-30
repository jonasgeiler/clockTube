local states = require('states._all')

local currState = ''

function love.load()
	currState = 'home'
end

function love.draw()
	states[currState]:draw()
end

function love.update()
	states[currState]:update()
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit()
	else
		states[currState].keypressed(k)
	end
end