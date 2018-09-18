local class = require('lib.class')
local config = require('conf')
local request = require('lib.request')
local Video = require('ui.videoList.video')
local Channel = require('ui.videoList.channel')

local VideoList = class {
	specs = {
		width = 300,
		height = 90,
		scrollingSpeedFactor = 10, -- the factor which the calculated scrolling speed gets divided through. The higher, the slower scrolling is.
		topOffsetScroll = 30, -- when scrolling up into selection, how much space between selected video and top
		bottomOffsetScroll = 20, -- when scrolling down into selection, how much space between selected video and bottom

		videosPerPage = 10
	}
}

function VideoList:newVideo(video, displayViews)
	local newVideo = {}
	
	newVideo.title = video.snippet.title
	newVideo.username = video.snippet.channelTitle
	newVideo.thumbnail = video.snippet.thumbnails.default.url
	if type(video.id) == "table" then
		video.id = video.id.videoId
	end
	newVideo.url = 'https://www.youtube.com/watch?v=' .. video.id
	if displayViews then
		newVideo.views = tonumber(video.statistics.viewCount)
	end
	
	return newVideo
end

function VideoList:newChannel(channel)
	local newChannel = {}
	
	newChannel.username = channel.snippet.title
	newChannel.avatar = channel.snippet.thumbnails.default.url
	newChannel.channelId = channel.id.channelId	
	newChannel.description = channel.snippet.description
	
	return newChannel
end

function VideoList:processResponse(response, displayViews)
	local videos = {}

	for i, item in pairs(response.items) do
		if type(item.id) == "table" and item.id.kind == "youtube#channel" then
			videos[i] = self:newChannel(item)
			videos[i].isChannel = true
		else
			videos[i] = self:newVideo(item, displayViews)
		end
	end

	self.nextPageToken = response.nextPageToken

	return videos
end

function VideoList:getTrendingVideos()
	local response = request('https://www.googleapis.com/youtube/v3/videos',
		{
			key = config.youtubeApiKey,
			part = 'snippet,statistics',
			chart = 'mostPopular',
			maxResults = self.specs.videosPerPage,
			pageToken = self.nextPageToken
		},
		true)

	return self:processResponse(response, true)
end

function VideoList:getVideosBySearch(term)
	local response = request('https://www.googleapis.com/youtube/v3/search',
		{
			key = config.youtubeApiKey,
			q = term,
			part = 'snippet',
			maxResults = self.specs.videosPerPage,
			pageToken = self.nextPageToken,
			type = 'video,channel'
		},
		true)

	return self:processResponse(response)
end

function VideoList:init(listType, data)
	self.selected = { index = 1, page = 1 }
	self.scroll = 0
	self.loadingVideos = false
	self.nextPageToken = ''
	
	self.videos = {}
	if listType == 'trending' then
		self.videos[1] = self:getTrendingVideos()
		self.loadNewVideos = function() return self:getTrendingVideos() end
	elseif listType == 'search' then
		self.videos[1] = self:getVideosBySearch(data)
		self.loadNewVideos = function() return self:getVideosBySearch(data) end
	elseif listType == 'user' then
		self.videos[1] = self:getVideosByUser(data)
		self.loadNewVideos = function() return self:getVideosByUser(data) end
	end

	for pageNum, page in ipairs(self.videos) do
		for i, item in ipairs(page) do
			if self.videos[pageNum][i].isChannel then
				self.videos[pageNum][i].obj = Channel(item)
			else
				self.videos[pageNum][i].obj = Video(item)
			end
		end
	end
end

function VideoList:draw(x, y)
	y = y + self.scroll

	local _, screenHeight = love.graphics.getDimensions()

	local currOffset = 0
	for pageNum, page in pairs(self.videos) do
		for i, video in ipairs(page) do
			if self.selected.index == i and self.selected.page == pageNum then -- if current video is selected
				if y + currOffset + video.obj.specs.height + self.scroll + self.specs.bottomOffsetScroll > screenHeight then
					local scrollingSpeed = (y + currOffset + video.obj.specs.height + self.scroll + self.specs.bottomOffsetScroll) - screenHeight
					self.scroll = self.scroll - scrollingSpeed / self.specs.scrollingSpeedFactor
				end

				if y + self.scroll + currOffset - self.specs.topOffsetScroll < 0 then
					local scrollingSpeed = -(y + self.scroll + currOffset - self.specs.topOffsetScroll)
					self.scroll = self.scroll + scrollingSpeed / self.specs.scrollingSpeedFactor
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
				love.graphics.setColor(228, 228, 228)
				love.graphics.rectangle('fill', 160 - rectWidth / 2, 120 - rectHeight / 2, rectWidth, rectHeight)
				love.graphics.setColor(0, 0, 0)
				love.graphics.print("Loading...", 130, 120 - rectHeight / 2 + 20)
				love.graphics.present()

				self.videos[self.selected.page + 1] = self:loadNewVideos()

				for i, video in ipairs(self.videos[self.selected.page + 1]) do
					self.videos[self.selected.page + 1][i].obj = Video(video)
				end

				self.loadingVideos = false
			end

			self.selected.page = self.selected.page + 1
			self.selected.index = 1
		end
	elseif key == "j" then
		local window_width, window_height, window_flags = love.window.getMode()
		love.window.close()
		os.execute('mplayer -framedrop -lavdopts threads=4 -vf scale -zoom -xy 320 -fs -cache 8192 -cookies -cookies-file ~/clockTube/cookie.txt ' ..
				'$(youtube-dl -f worst[ext=mp4] -g --cookies ~/clockTube/cookie.txt "' ..
				self.videos[self.selected.page][self.selected.index].url ..
				'") > ~/mplayer.log 2>&1')
		love.window.setMode(window_width, window_height, window_flags)
	end
end

return VideoList