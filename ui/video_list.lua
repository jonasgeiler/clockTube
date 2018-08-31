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
		bottomOffsetScroll = 20, -- when scrolling down into selection, how much space between selected video and bottom
		
		videosPerPage = 10
	},
	videos = {},
	selected = { index = 1, page = 1},
	scroll = 0,
	loadingVideos = false,
	
	nextPageToken = ''
}

function VideoList:getTrendingVideos()
	local response = request(
		'https://www.googleapis.com/youtube/v3/videos', 
		{
			key = config.youtubeApiKey,
			part = 'snippet,statistics',
			chart = 'mostPopular',
			maxResults = self.specs.videosPerPage,
			pageToken = self.nextPageToken
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
	
	self.nextPageToken = response.nextPageToken
	
	return videos
end

function VideoList:init(list, data)
	if list == 'trending' then
		self.videos[1] = self:getTrendingVideos()
	elseif list == 'search' then
		self.videos[1] = self:getVideosBySearch(data)
	elseif list == 'user' then
		self.videos[1] = self:getVideosByUser(data)
	end
	
	for pageNum,page in ipairs(self.videos) do
		for i,video in ipairs(page) do
			self.videos[pageNum][i].obj = Video(video)
		end
	end
end

function VideoList:draw(x, y)
	y = y + self.scroll
	
	local _,screenHeight = love.graphics.getDimensions()
	
	local currOffset = 0
	for pageNum,page in pairs(self.videos) do
		for i,video in ipairs(page) do
			if self.selected.index == i and self.selected.page == pageNum then -- if current video is selected
				if y + currOffset + video.obj.specs.height + self.scroll + self.specs.bottomOffsetScroll > screenHeight then
					local scrollingSpeed = (y + currOffset + video.obj.specs.height + self.scroll + self.specs.bottomOffsetScroll) - screenHeight
					self.scroll = self.scroll - scrollingSpeed/self.specs.scrollingSpeedFactor
				end
				
				if y + self.scroll + currOffset - self.specs.topOffsetScroll < 0 then
					local scrollingSpeed = -(y + self.scroll + currOffset - self.specs.topOffsetScroll)
					self.scroll = self.scroll + scrollingSpeed/self.specs.scrollingSpeedFactor
				end
			end
			
			if y + self.scroll + currOffset < screenHeight and y + currOffset + video.obj.specs.height + self.scroll > 0 then -- if video is inside window
				video.obj:draw(x, y + self.scroll + currOffset, (self.selected.index == i and self.selected.page == pageNum))
			end
			
			currOffset = currOffset + video.obj.specs.height + 10
		end
	end
end

function VideoList:keypressed(key)
	if self.loadingVideos then
		return
	end
	
	if key == "up" then
		self.selected.index = self.selected.index - 1
		
		if self.selected.index <= 0 then
			if self.selected.page ~= 1 then
				self.selected.page = self.selected.page - 1
				self.selected.index = self.specs.videosPerPage
			else
				self.selected.index = 1
			end
		end
	elseif key == "down" then
		self.selected.index = self.selected.index + 1
		
		if self.selected.index > #self.videos[self.selected.page] then
			if self.selected.page == #self.videos then -- page is last page. Load more videos
				self.loadingVideos = true
				
				local rectHeight, rectWidth = 50, 100
				love.graphics.setColor(228,228,228)
				love.graphics.rectangle('fill', 160-rectWidth/2, 120-rectHeight/2, rectWidth, rectHeight)
				love.graphics.setColor(0,0,0)
				love.graphics.print("Loading...", 130, 120-rectHeight/2+20)
				love.graphics.present()
				
				self.videos[self.selected.page + 1] = self:getTrendingVideos()
				
				for i,video in ipairs(self.videos[self.selected.page + 1]) do
					self.videos[self.selected.page + 1][i].obj = Video(video)
				end
				
				self.loadingVideos = false
			end
			
			self.selected.page = self.selected.page + 1
			self.selected.index = 1
		end
	elseif key == "j" then
		love.window.close()
		os.execute('playVideo.sh ' .. self.videos[self.selected.page][self.selected.index].url)
	end
end

return VideoList