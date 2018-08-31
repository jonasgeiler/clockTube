local class = require('lib.class')
local fonts = require('assets.fonts._all')

local TextInput = class{
	inputTitleBar = nil,
	layout = 1,
	
	cursor = {x=1, y=1},
	
	specs = {
		keyboardCols = 10,
		keyboardRows = 4,
		
		keyWidth = 29.75,
		keyHeight = 22,
		
		keyboardY = 119
	},
	
	layouts = {
		{
			name = 'abc',
			rows = {
				'1234567890',
				'qwertyuiop',
				"asdfghjkl'",
				'zxcvbnm,.?'
			}
		},
		{
			name = 'ABC',
			rows = {
				'1234567890',
				'QWERTYUIOP',
				'ASDFGHJKL"',
				'ZXCVBNM;:!'
			}
		},
		{
			name = '123',
			rows = {
				',;:\'"!?  %', -- ¡¿
				'[]{}`$  #', --- £«»
				'<>()   ~^\\', -- €¥
				'|=*/+-@_&.',
			}
		}
	}
}

function TextInput:init(inputTitleBar)
	self.inputTitleBar = inputTitleBar
	
	for i,layout in pairs(self.layouts) do
		-- nice little snippet to be able to access a char with currLayout(x,y)
		setmetatable(self.layouts[i].rows, {
			__call = function(t, x, y)
				return t[y]:sub(x,x)
			end
		})
	end
end

function TextInput:draw()
	local currLayout = self.layouts[self.layout].rows
	
	local currOffsetX, currOffsetY = 1, self.specs.keyboardY
	
	-- Keys
	for y = 1,self.specs.keyboardRows do
		for x = 1,self.specs.keyboardCols do
			if self.cursor.x == x and self.cursor.y == y then
				love.graphics.setColor(51,166,255)
				love.graphics.rectangle('fill', x + currOffsetX, y + currOffsetY, self.specs.keyWidth, self.specs.keyHeight)
			end
			
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle('line', x + currOffsetX, y + currOffsetY, self.specs.keyWidth, self.specs.keyHeight)
			
			local char = love.graphics.newText(fonts.SegoeUI_bold, currLayout(x,y))
			love.graphics.draw(char, x + currOffsetX + 10, y + currOffsetY + 3)
			
			currOffsetX = currOffsetX + self.specs.keyWidth + 1
		end
		
		currOffsetY = currOffsetY + self.specs.keyHeight + 1
		currOffsetX = 1
	end
	
	-- Spacebar
	currOffsetX = (currOffsetX + self.specs.keyWidth + 1) * 2
	
	if self.cursor.y == 5 then
		love.graphics.setColor(51,166,255)
		love.graphics.rectangle('fill', 4 + currOffsetX, 5 + currOffsetY, (self.specs.keyWidth+1)*6, self.specs.keyHeight)
	end
	
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle('line', 4 + currOffsetX, 5 + currOffsetY, (self.specs.keyWidth+1)*6, self.specs.keyHeight)
	
	local spaceText = love.graphics.newText(fonts.SegoeUI_bold, 'Space')
	love.graphics.draw(spaceText, 4 + currOffsetX + 75, 5 + currOffsetY + 3)
end

function TextInput:keypressed(k)
	if k == 'up' then
		self.cursor.y = self.cursor.y - 1
	end
	
	if k == 'down' then
		self.cursor.y = self.cursor.y + 1
	end
	
	if k == 'left' then
		self.cursor.x = self.cursor.x - 1
	end
	
	if k == 'right' then
		self.cursor.x = self.cursor.x + 1
	end
	
	if k == 'u' then
		self.layout = self.layout + 1
		if self.layout > 3 then
			self.layout = 1
		end
		
		local nextLayout = self.layout + 1
		if nextLayout > 3 then
			nextLayout = 1
		end
		
		self.inputTitleBar:setActions({
			{
				key = 'A',
				label = 'Enter'
			},
			{
				key = 'B',
				label = 'Del'
			},
			{
				key = 'Y',
				label = 'Done'
			},
			{
				key = 'X',
				label = self.layouts[nextLayout].name
			},
			{
				key = 'nav',
				label = 'Move'
			}
		})
	end
end

return TextInput