local class = require('lib.class')
local fonts = require('assets.fonts._all')

local TitleBar = class{
	specs = {
		width = 320,
		height = 20,
		x = 0,
		y = 0
	},
	icons = {},
	
	text = 'clockTube',
	actions = {}
}

function TitleBar:init(text, actions)
	self.text = love.graphics.newText(fonts.SegoeUI, text)
	self.actions = {}
	self:setActions(actions)
end

function TitleBar:setActions(actions)
	for i,action in ipairs(actions) do
		local newAction = {}
		newAction.icon = love.graphics.newImage('assets/images/icons/icon_' .. action.key .. '.png')
		newAction.label = love.graphics.newText(fonts.SegoeUI, action.label)
		
		self.actions[i] = newAction
	end
end

function TitleBar:draw()
	-- Bar Background + Border
	love.graphics.setColor(228,228,228)
	love.graphics.rectangle('fill', self.specs.x, self.specs.y, self.specs.width, self.specs.height)
	love.graphics.setColor(169,169,169)
	love.graphics.setLineStyle('rough')
	love.graphics.line(
		self.specs.x, 
		self.specs.y + self.specs.height,
		self.specs.x + self.specs.width, 
		self.specs.y + self.specs.height
	)
	
	-- Title Text
	love.graphics.setColor(0,0,0)
	love.graphics.draw(self.text, 4, 2)
	
	-- Actions
	local currOffset = 0
	for i,action in ipairs(self.actions) do
		love.graphics.setColor(0,0,0)
		love.graphics.draw(action.label, self.specs.width - currOffset - action.label:getWidth() - 7, 2)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(action.icon, self.specs.width - currOffset - action.label:getWidth() - 25, 2)
		
		currOffset = currOffset + action.label:getWidth() + action.icon:getWidth() + 10
	end
end

return TitleBar