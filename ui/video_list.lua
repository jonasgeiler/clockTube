local class = require('lib.class')
local Video = require('ui.video')

local VideoList = class{
	specs = {
		width = 300,
		height = 90
	},
	videos = {},
	selected = 1,
	scroll = 0
}

function VideoList:init(videos)
	self.videos = videos
	
	for i,videoData in ipairs(self.videos) do
		self.videos[i].obj = Video(videoData)
	end
end

function VideoList:draw(x, y)
	y = y + self.scroll
	
	local currOffset = 0
	for i,videoData in ipairs(self.videos) do
		if self.selected == i then -- if current video is selected
			local _,screenHeight = love.graphics.getDimensions()
			if y + currOffset + videoData.obj.specs.height + self.scroll + 20 > screenHeight then
				self.scroll = self.scroll - 5
			end
			
			if y + self.scroll + currOffset - 30 < 0 then
				self.scroll = self.scroll + 5
			end
		end
		
		videoData.obj:draw(x, y + self.scroll + currOffset, (self.selected == i))
		
		currOffset = currOffset + videoData.obj.specs.height + 10
	end
end

function VideoList:keypressed(key)
	if key == "up" then
		self.selected = self.selected - 1
		
		if self.selected <= 0 then
			self.selected = 1
		end
	elseif key == "down" then
		self.selected = self.selected + 1
	elseif key == "s" then
		self.scroll = self.scroll - 1
	end
end

return VideoList