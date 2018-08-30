local class = require('lib.class')
local formatNumber = require('lib.formatNumber')
local fonts = require('assets.fonts._all')
local http = require('socket.http')

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
		title_cut_length = 60, -- when to cut the title and add "..."
		
		border_padding = 3 -- space between video box and selected-border
	}
}

function newImageFromURL(url, name)
	local rawThumbnailData = http.request(url)
	local fileData = love.filesystem.newFileData(rawThumbnailData, 'thumbnail.png', 'file')
	local imageData = love.image.newImageData(fileData)
	return love.graphics.newImage(imageData)
end

function fixUTF8(s, replacement)
  local p, len, invalid = 1, #s, {}
  while p <= len do
    if     p == s:find("[%z\1-\127]", p) then p = p + 1
    elseif p == s:find("[\194-\223][\128-\191]", p) then p = p + 2
    elseif p == s:find(       "\224[\160-\191][\128-\191]", p)
        or p == s:find("[\225-\236][\128-\191][\128-\191]", p)
        or p == s:find(       "\237[\128-\159][\128-\191]", p)
        or p == s:find("[\238-\239][\128-\191][\128-\191]", p) then p = p + 3
    elseif p == s:find(       "\240[\144-\191][\128-\191][\128-\191]", p)
        or p == s:find("[\241-\243][\128-\191][\128-\191][\128-\191]", p)
        or p == s:find(       "\244[\128-\143][\128-\191][\128-\191]", p) then p = p + 4
    else
      s = s:sub(1, p-1)..replacement..s:sub(p+1)
      table.insert(invalid, p)
    end
  end
  return s, invalid
end

function Video:init(data)
	self.thumbnail = newImageFromURL(data.thumbnail, 'thumbnail.png')
	self.username = love.graphics.newText(fonts.SegoeUI_light, data.username)
	self.views = love.graphics.newText(fonts.SegoeUI_light, formatNumber(data.views, 0) .. ' Views')
	
	if data.title:len() > self.specs.title_cut_length then
		data.title = data.title:sub(0, self.specs.title_cut_length) .. "..."
	end
	
	if data.title:len() > self.specs.title_wrap_length then
		data.title = data.title:sub(0, self.specs.title_wrap_length) .. "\n" .. data.title:sub(self.specs.title_wrap_length+1)
	end
	
	self.title = love.graphics.newText(fonts.SegoeUI_bold, fixUTF8(data.title, ''))
end

function drawDashedLine(x1, y1, x2, y2, min, max)
	min = min or 0
	max = max or 8
	
	love.graphics.setPointSize(2)

	local x, y = x2 - x1, y2 - y1
	local len = math.sqrt(x^2 + y^2)
	local stepx, stepy = x / len, y / len
	x = x1
	y = y1

	for i = 1, len do
		local lastDigit = tonumber(tostring(i):sub(-1))
		if lastDigit > min and lastDigit < max then
			love.graphics.points(x, y)
		end
		
		x = x + stepx
		y = y + stepy
	end
end

function Video:draw(x, y, selected)
	-- Thumbnail
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.thumbnail, x, y)
	
	-- Title
	love.graphics.setColor(20,20,20)
	love.graphics.draw(self.title, x + 125, y+5)
	love.graphics.draw(self.username, x + 127, y+40)
	love.graphics.draw(self.views, x + 127, y+55)
	
	-- Selection Border
	if selected then
		love.graphics.setColor(51,166,255)
		drawDashedLine(x - self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding)
		drawDashedLine(x - self.specs.border_padding-1, y - self.specs.border_padding, x - self.specs.border_padding-1, y + self.specs.height + self.specs.border_padding)
		drawDashedLine(x - self.specs.border_padding-1, y + self.specs.height + self.specs.border_padding+1, x + self.specs.width + self.specs.border_padding+1, y + self.specs.height + self.specs.border_padding+1)
		drawDashedLine(x + self.specs.width + self.specs.border_padding, y - self.specs.border_padding, x + self.specs.width + self.specs.border_padding, y + self.specs.height + self.specs.border_padding)
	end
end

return Video