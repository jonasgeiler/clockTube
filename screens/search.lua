local class = require('lib.class')
local TextInput = require('ui.text_input')
local TitleBar = require('ui.title_bar')

local Search = class {
	activeScreen = nil, -- screen manager

	inputTitleBar = nil,
	resultsTitleBar = nil,
	textInput = nil,
	inputSearch = true
}

function Search:init()
	self.inputTitleBar = TitleBar('Search', {
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
			label = 'ABC'
		},
		{
			key = 'nav',
			label = 'Move'
		}
	})

	self.resultsTitleBar = TitleBar('Search', {
		{
			key = 'A',
			label = 'Play'
		},
		{
			key = 'B',
			label = 'Home'
		},
		{
			key = 'Y',
			label = 'New Search'
		},
		{
			key = 'nav',
			label = 'Select'
		}
	})

	self.textInput = TextInput(self.inputTitleBar)
end

function Search:draw()
	love.graphics.setBackgroundColor(255, 255, 255)

	if self.inputSearch then
		self.textInput:draw()
		self.inputTitleBar:draw()
	else
		self.resultsTitleBar:draw()
	end
end

function Search:update()
end

function Search:keypressed(k)
	if self.inputSearch then
		self.textInput:keypressed(k)
	else
		if k == 'k' then
			self.activeScreen = 'home'
		end

		if k == 'i' then
			self.inputSearch = true
		end

		self.videoList:keypressed(k)
	end
end

return Search