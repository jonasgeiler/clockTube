local class = require('lib.class')
local TitleBar = require('ui.titleBar')
local VideoList = require('ui.videoList')

local Home = class {
	activeScreen = nil -- screen manager
}

function Home:init()
	self.videoList = VideoList('trending')

	self.homeTitleBar = TitleBar('Home', {
		{
			key = 'A',
			label = 'Play'
		},
		{
			key = 'Y',
			label = 'Search'
		},
		{
			key = 'nav',
			label = 'Select'
		}
	})
end

function Home:draw()
	love.graphics.setBackgroundColor(255, 255, 255)

	self.videoList:draw(10, 30)
	self.homeTitleBar:draw() -- is overlay so draw at the end
end

function Home:update()
end

function Home:keypressed(k)
	if k == 'i' then
		self.activeScreen = 'search'
	else
		self.videoList:keypressed(k)
	end
end

return Home