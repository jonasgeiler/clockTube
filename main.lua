currKey = ""

function love.load()
    love.window.setMode(320, 240)
end

function love.draw()
    love.graphics.print(currKey, 160, 120)
end

function logKey(k)
    currKey = k
end

function love.keypressed(k)
 if k == "escape" then
   love.event.quit()
 end
 logKey(k)
end

function love.gamepadpressed(_,k)
 logKey(k)
end

function love.joystickpressed(_,k)
 logKey(k)
end
