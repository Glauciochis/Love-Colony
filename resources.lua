local resources = {}
resources.root_directory = 'assets/'
resources.resource_types = {
	['png']='sprite',['jpg']='sprite',['jpeg']='sprite'
	,['ogg']='audio',['mp3']='audio'
	,['ttf']='font',['otf']='font'
	,['glsl']='shader'
	
	,sprite={['png']=true,['jpg']=true,['jpeg']=true}
	,audio={['ogg']=true,['mp3']=true}
	,font={['ttf']=true,['otf']=true}
	,shader={['glsl']=true}
}
local _img = {}
local _spr = {}



function resources.initialise()
	-- load an error sprite for returning when a sprite doesn't exist
	love.graphics.setDefaultFilter('nearest', 'nearest')
	_img.error = love.graphics.newImage(resources.root_directory..'/error.png')
	local w, h = _img.error:getWidth(), _img.error:getHeight()
	_spr.error = love.graphics.newQuad(0, 0, w, h, _img.error)
end
function resources.update()
	
end

--- Retrieves or loads the sprite requested.
--- @param sprite table Table of the sprite (sheet, sprite, frame)
--- @return Image sheet
--- @return Quad|table sprite
function resources.getSprite(sprite)
	if not _spr[ sprite[1] ] then
		resources.loadSheet(sprite[1])
	end
	if _spr[ sprite[1] ] then
		local sh = _img[ sprite[1] ][1]
		local sp = _spr[ sprite[1] ][1]
		for i=2, #sprite, 1 do sp = sp[ sprite[i] ] end
		return sh, sp
	end
	
	return _img.error, _spr.error
end

--- Load sprite-sheet from given sheet uri.
--- @param sheet string
function resources.loadSheet(sheet)
	local ext = false
	local path = resources.root_directory..sheet
	-- find which extention this sheet uses
	for e, bool in pairs(resources.resource_types.sprite) do
		if love.filesystem.getInfo(path..'.'..e..'.meta') then ext = e end
	end
	
	-- load the image and metadata
	local img = love.graphics.newImage(path..'.'..ext)
	local data = 'return '..love.filesystem.read(path..'.'..ext..'.meta')
	local chunk, err = loadstring(data)
	if chunk then
		local status, data = pcall(chunk)
		if status then
			_img[sheet] = {img, love.timer.getTime()}
			_spr[sheet] = {{}, love.timer.getTime()}
			-- create quads for sprites
			local grid_w = (data.grid and data.grid[1]) or 1
			local grid_h = (data.grid and data.grid[2]) or 1
			resources.loadSprite(img, _spr[sheet][1], data.sprites, grid_w, grid_h)
		else
			print('Warning: sheet '..sheet..' could not be loaded.', data)
		end
	else
		print('Warning: sheet '..sheet..' could not be loaded.', err)
	end
end
--- Loads quads from data.
--- @param img Image Reference image to use while creating the quad
--- @param container table Container to put the finished quads
--- @param data table Sprite data to parse for creation
--- @param grid_w number Grid cell width
--- @param grid_h number Grid cell height
function resources.loadSprite(img, container, data, grid_w, grid_h)
	for k, spr in pairs(data) do
		if type(spr[1]) == 'table' then
			container[k] = {}
			resources.loadSprite(img, container[k], spr, grid_w, grid_h)
		else
			local x, y = spr[1] * grid_w, spr[2] * grid_h
			local w, h = spr[3] and (spr[3] * grid_w) or grid_w, spr[4] and (spr[4] * grid_h) or grid_h
			container[k] = love.graphics.newQuad(x, y, w, h, img)
		end
	end
end


return resources