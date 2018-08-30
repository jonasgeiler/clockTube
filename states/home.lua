local class = require('lib.class')
local VideoList = require('ui.video_list')
local TitleBar = require('ui.title_bar')

local Home = class{
	videoList = nil,
	titleBar = nil
}

function Home:init()
	self.videoList = VideoList({
		{
			title = 'This is a video - Episode #1 [GERMAN]',
			username = 'Skayo',
			views = 10000,
			thumbnail = '',
			url = 'https://youtube.com/watch?q=123',
			selected = true
		},
		{
			title = 'This is also a video - Episode #2 [GERMAN] - thisisalongtitlewoowcoolvery',
			username = 'Skayo',
			views = 10001,
			thumbnail = '',
			url = 'https://youtube.com/watch?q=1234',
			selected = false
		},
		{
			title = 'This is a video - Episode #1 [GERMAN]',
			username = 'Skayo',
			views = 10000,
			thumbnail = '',
			url = 'https://youtube.com/watch?q=123',
			selected = true
		},
		{
			title = 'This is also a video - Episode #2 [GERMAN] - thisisalongtitlewoowcoolvery',
			username = 'Skayo',
			views = 10001,
			thumbnail = '',
			url = 'https://youtube.com/watch?q=1234',
			selected = false
		}
	})
	
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
	self.videoList:keypressed(k)
end

return Home