local class = require('lib.class')
local Video = require('ui.video')

local VideoList = class{
	specs = {
		width = 300,
		height = 90
	},
	videos = {}
}

function VideoList:init(videos)
	self.videos = {
		{
			title = 'This is a video - Episode #1 [GERMAN]',
			username = 'Skayo',
			views = 10000,
			thumbnail = '',
			url = 'https://youtube.com/watch?q=123'
		},
		{
			title = 'This is also a video - Episode #2 [GERMAN] - this is a long title woow',
			username = 'Skayo',
			views = 10001,
			thumbnail = '',
			url = 'https://youtube.com/watch?q=1234'
		}
	}
	
	for i,videoData in pairs(self.videos) do
		self.videos[i].obj = Video(videoData)
	end
end

function VideoList:draw(x, y)
	for i,videoData in pairs(self.videos) do
		videoData.obj:draw(x, y+100*(i-1))
	end
end

return VideoList