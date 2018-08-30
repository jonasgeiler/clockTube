local class = require('lib.class')
local Video = require('ui.video')

local VideoList = class{
	specs = {
		width = 300,
		height = 90
	},
	videos = {},
	selected = 1
}

function VideoList:init(videos)
	self.videos = {
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
	}
	
	for i,videoData in ipairs(self.videos) do
		self.videos[i].obj = Video(videoData)
	end
end

function VideoList:draw(x, y)
	local currOffset = 0
	for i,videoData in ipairs(self.videos) do
		videoData.obj:draw(x, y + currOffset, (self.selected == i))
		
		currOffset = currOffset + videoData.obj.specs.height + 10
	end
end

function VideoList:keypressed(key)
	if key == "up" then
		self.selected = self.selected - 1
	elseif key == "down" then
		self.selected = self.selected + 1
	end
end

return VideoList