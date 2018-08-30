local class = require('lib.class')
local formatNumber = require('lib.formatNumber')
local fonts = require('assets.fonts._all')

local Video = class{
	username = '',
	views = 0,
	title = '',
	thumbnail = '',
	url = '',
	
	specs = {
		width = 300,
		height = 90,
		
		title_wrap_length = 32, -- when to add a newline
		title_cut_length = 60 -- when to cut the title and add "..."
	}
}

function newImageFromURL(url, name)
	local rawThumbnailData = request.get(url)
	return love.graphics.newImage(love.filesystem.newFileData(rawThumbnailData, name:gsub("_", "."), "base64"))
end

function Video:init(data)
	--video.data.thumbnail = newImageFromURL('https://i.ytimg.com/vi/9KoAESKcyLg/hqdefault.png?sqp=-oaymwEYCNIBEHZIVfKriqkDCwgBFQAAiEIYAXAB&rs=AOn4CLCzwd-VSXo8KrFarUqHXW8U9rDzZA', 'thumbnail.png')
	self.username = love.graphics.newText(fonts.SegoeUI_light, data.username)
	self.views = love.graphics.newText(fonts.SegoeUI_light, formatNumber(data.views, 0) .. ' Views')
	
	if data.title:len() > self.specs.title_cut_length then
		data.title = data.title:sub(0, self.specs.title_cut_length) .. "..."
	end
	
	if data.title:len() > self.specs.title_wrap_length then
		data.title = data.title:sub(0, self.specs.title_wrap_length) .. "\n" .. data.title:sub(self.specs.title_wrap_length+1)
	end
	
	self.title = love.graphics.newText(fonts.SegoeUI_bold, data.title)
end

function Video:draw(x, y)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle('line', x, y, self.specs.width, self.specs.height)
	
	-- Thumbnail
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle('fill', x, y, 120, 90)
	
	
	-- Title
	love.graphics.setColor(20,20,20)
	love.graphics.draw(self.title, x + 125, y+5)
	love.graphics.draw(self.username, x + 127, y+40)
	love.graphics.draw(self.views, x + 127, y+55)
end

return Video