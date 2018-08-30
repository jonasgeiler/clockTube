local class = require('lib.class')
local VideoList = require('ui.video_list')

local Home = class{
	videoList = nil
}

function Home:init()
	self.videoList = VideoList({})
	
	return self
end

function Home:draw()
	love.graphics.setBackgroundColor(255,255,255)
	self.videoList:draw(10,10)
end

function Home:update()
	
end

function Home:keypressed(k)
	
end

return Home