--Configuration File
function love.conf(t)
	t.title = "Calculator"
	t.window.width = 320
	t.window.height = 240

	--t.console = true
	
	t.modules.physics = false
	t.modules.sound = false
	t.modules.mouse = false
	t.modules.audio = false
	t.modules.filesystem = false
	t.modules.image = false
	t.modules.touch = false
	
	t.window.resizable = false
	t.window.borderless = true
end
