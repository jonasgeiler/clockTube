local class = require('lib.class')
local VideoList = require('ui.video_list')
local TitleBar = require('ui.title_bar')

local Home = class{
	activeScreen = '',
	
	videoList = nil,
	titleBar = nil
}

function Home:init()
	self.videoList = VideoList('trending')
	
	self.titleBar = TitleBar('Home', {
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
	love.graphics.setBackgroundColor(255,255,255)
	
	self.videoList:draw(10,30)
	self.titleBar:draw() -- is overlay so draw at the end
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