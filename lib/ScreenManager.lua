-- written by Skayo
-- feel free to use!
-- (requires hump.class or similar + a <class>.active variable)

local class = require('lib.class')

local ScreenManager = class {
	active = '',
	screens = {}
}

function ScreenManager:init(screens, active)
	self.active = active
	self.screens = screens
end

function ScreenManager:check()
	for i, screen in pairs(self.screens) do
		if screen.activeScreen == nil then
			self.screens[i].activeScreen = self.active
		end

		if screen.activeScreen ~= self.active then
			self.active = screen.activeScreen

			for j, _ in pairs(self.screens) do
				self.screens[j].activeScreen = self.active
			end
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