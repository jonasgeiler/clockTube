local class = require('lib.class')
local TextInput = require('ui.text_input')
local TitleBar = require('ui.title_bar')
local VideoList = require('ui.video_list')

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

	self.textInput = TextInput('Enter Search...', self.inputTitleBar)
end

function Search:draw()
	love.graphics.setBackgroundColor(255, 255, 255)

	if self.inputSearch then
		self.textInput:draw()
		self.inputTitleBar:draw()
	else
		self.resultsTitleBar:draw()
		self.videoList:draw(10, 30)
	end
end

function Search:update(dt)
	if self.inputSearch then
		self.textInput:update(dt)
	end
end

function Search:keypressed(k)
	if self.inputSearch then
		if k == 'i' then
			self.inputSearch = false
			
			self.videoList = VideoList('search', self.textInput.currInput)
		end
		
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