local class = require('lib.class')

local ScreenManager = class{
	active = '',
	screens = {}
}

function ScreenManager:init(screens, active)
	self.active = active
	self.screens = screens
end

function ScreenManager:check()
	for _,screen in pairs(self.screens) do
		if screen.activeScreen ~= '' then
			self.active = screen.activeScreen
			screen.activeScreen = ''
		end
	end
end

function ScreenManager:load()
	self.screens[self.active]()
end

function ScreenManager:draw()
	self.screens[self.active]:draw()
end

function ScreenManager:keypressed(k)
	self.screens[self.active]:keypressed(k)
end

function ScreenManager:update(dt)
	self:check()
	
	self.screens[self.active]:update(dt)
end

return ScreenManager