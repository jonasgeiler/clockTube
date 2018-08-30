local class = require('lib.class')
local VideoList = require('ui.video_list')
local TitleBar = require('ui.title_bar')

local Home = class{
	videoList = nil,
	titleBar = nil
}

function Home:init()
	self.videoList = VideoList({})
	self.titleBar = TitleBar('clockTube - Home', {
		{
			key = 'A',
			label = 'Select'
		},
		{
			key = 'Y',
			label = 'Search'
		},
		{
			key = 'nav',
			label = 'Scroll'
		}
	})
	
	return self
end

function Home:draw()
	love.graphics.setBackgroundColor(255,255,255)
	
	self.videoList:draw(10,30)
	self.titleBar:draw() -- is overlay so draw at the end
end

function Home:update()
	
end

function Home:keypressed(k)
	
end

return Home