local class = require('lib.class')
local config = require('conf')
local request = require('lib.request')
local Video = require('ui.video')

local VideoList = class{
	specs = {
		width = 300,
		height = 90,
		
		scrollingSpeedFactor = 10, -- the factor which the calculated scrolling speed gets divided through. The higher, the slower scrolling is.
		topOffsetScroll = 30, -- when scrolling up into selection, how much space between selected video and top
		bottomOffsetScroll = 20 -- when scrolling down into selection, how much space between selected video and bottom
	},
	videos = {},
	selected = 1,
	scroll = 0
}

function getTrendingVideos()
	local response = request(
		'https://www.googleapis.com/youtube/v3/videos', 
		{
			key = config.youtubeApiKey,
			part = 'snippet,statistics',
			chart = 'mostPopular',
			maxResults = 10
		},
		true
	)
	
	local videos = {}
	
	for i,video in pairs(response.items) do
		local newVideo = {}
		newVideo.title = video.snippet.title
		newVideo.username = video.snippet.channelTitle
		newVideo.thumbnail = video.snippet.thumbnails.default.url
		newVideo.views = tonumber(video.statistics.viewCount)
		newVideo.url = 'https://www.youtube.com/watch?v=' .. video.id
		
		videos[i] = newVideo
	end
	
	return videos
end

function VideoList:init(list, data)
	if list == 'trending' then
		self.videos = getTrendingVideos()
	elseif list == 'search' then
		self.videos = getVideosBySearch(data)
	elseif list == 'user' then
		self.videos = getVideosByUser(data)
	end
	
	for i,videoData in ipairs(self.videos) do
		self.videos[i].obj = Video(videoData)
	end
end

function VideoList:draw(x, y)
	y = y + self.scroll
	
	local _,screenHeight = love.graphics.getDimensions()
	
	local currOffset = 0
	for i,videoData in ipairs(self.videos) do
		
		if self.selected == i then -- if current video is selected
			if y + currOffset + videoData.obj.specs.height + self.scroll + self.specs.bottomOffsetScroll > screenHeight then
				local scrollingSpeed = (y + currOffset + videoData.obj.specs.height + self.scroll + self.specs.bottomOffsetScroll) - screenHeight
				self.scroll = self.scroll - scrollingSpeed/self.specs.scrollingSpeedFactor
			end
			
			if y + self.scroll + currOffset - self.specs.topOffsetScroll < 0 then
				local scrollingSpeed = -(y + self.scroll + currOffset - self.specs.topOffsetScroll)
				self.scroll = self.scroll + scrollingSpeed/self.specs.scrollingSpeedFactor
			end
		end
		
		if y + self.scroll + currOffset < screenHeight and y + currOffset + videoData.obj.specs.height + self.scroll > 0 then -- if video is inside window
			videoData.obj:draw(x, y + self.scroll + currOffset, (self.selected == i))
		end
		
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
		
		if self.selected > #self.videos then
			self.selected = #self.videos
		end
	end
end

return VideoList