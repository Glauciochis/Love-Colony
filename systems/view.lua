local view = {}
local _view = {}


function view.initialise()
	view.create('main', 'test_world')
end

-- general
--- Creates a view for later use.
--- @param name string Name of the view, used to get and manipulate the view
--- @param world string Name of the world the view shows
--- @param vx number Position on the x axis the view takes on the screen (0-1)
--- @param vy number Position on the y axis the view takes on the screen (0-1)
--- @param vw number Width of the view on the screen (0-1)
--- @param vh number Height of the view on the screen (0-1)
--- @param scale number Scale/zoom of the view in the world
function view.create(name, world, vx, vy, vw, vh, scale)
	local ww, wh = love.window.getMode()
	scale = scale or 3
	_view[name] = {
		name = name
		,world = world
		,x=0,y=0,z=0
		,w=scale,h=scale,wcalc=1/scale,hcalc=1/scale
		,rot=0
		,cx=.5,cy=.5,mx=0,my=0
		,vx=vx or 0,vy=vy or 0,vw=vw or 1,vh=vh or 1
		,canvas=love.graphics.newCanvas(ww*(vw or 1), wh*(vh or 1), { type = "2d", format = "normal", readable = true })
	}
end
--- Gets a view by its name.
--- @param name string
--- @return table view
function view.get(name)
	return _view[name]
end
--- Gets a list of all views (list of their names).
--- @return table view_names
function view.getList()
	local list = {}
	for n, v in pairs(_view) do
		table.insert(list, n)
	end
	return list
end
--- Sets the viewport of a view.
--- @param name string
--- @param x number Position on the x axis on the screen (0-1)
--- @param y number Position on the y axis on the screen (0-1)
--- @param w number Width of the view on the screen
--- @param h number Height of the view on the screen
function view.setViewport(name, x, y, w, h)
	local v = _view[name]
	if not v then print('Warning: no view with name '..name..' exists (in setViewport).') return end
	v.vx = x
	v.vy = y
	v.vw = w
	v.vh = h
	local ww, wh = love.window.getMode()
	v.canvas = love.graphics.newCanvas(ww*v.vw, wh*v.vh, { type = "2d", format = "normal", readable = true })
end
--- Sets the size of the view (in world).
--- @param name string
--- @param w number
--- @param h number
function view.setSize(name, w, h)
	local v = _view[name]
	if not v then print('Warning: no view with name '..name..' exists (in setSize).') return end
	v.w = w
	v.h = h or w
	v.wcalc = 1/v.w
	v.hcalc = 1/v.h
end
--- Sets the position of the view (in world).
--- @param name string
--- @param x number
--- @param y number
function view.setPosition(name, x, y)
	local v = _view[name]
	if not v then print('Warning: no view with name '..name..' exists (in setPosition).') return end
	v.x = x
	v.y = y
end
--- Sets the centre of the view.
--- @param name string
--- @param x number Centre of view on the x axis (0-1)
--- @param y number Centre of view on the y axis (0-1)
function view.setCentre(name, x, y)
	local v = _v[name]
	if not v then print('Warning: no view with name '..name..' exists (in setCentre).') return end
	v.cx = x
	v.cy = y
end
--- Sets the rotation of the view.
--- @param name string
--- @param r number
function view.setRotation(name, r)
	local v = _v[name]
	if not v then print('Warning: no view with name '..name..' exists (in setRotation).') return end
	v.r = r
end
--- Gets the x and y position of the mouse based on the transform of the view.
--- @param name string
function view.getMousePosition(name)
	local v = _view[name]
	if not v then print('Warning: no view with name '..name..' exists (in getMousePosition).') return end
	return v.mx, v.my
end

--- Renders the given or all views.
--- @param name? string
--- @param ww number Window width
--- @param wh number Window height
function view.render(name, ww, wh)
	-- render all views if no view is given
	if not wh then
		for n, v in pairs(_view) do
			view.render(n, name, ww)
		end
		return
	end
	
	-- set up variables and push graphics state
	local v = _view[name]
	if not v then print('Warning: no view with name '..name..' exists (in render).') return end
	ww = ww * v.vw
	wh = wh * v.vh
	love.graphics.push()
	
	-- set canvas to be the view's canvas
	love.graphics.setCanvas(v.canvas)
	love.graphics.clear(0, 0, 0, 1)
	
	-- transform graphics state
	love.graphics.translate(ww*(v.cy or .5), wh*(v.cx or .5))
	love.graphics.scale(v.w or 1, v.h or 1)
	love.graphics.translate(-v.x, -v.y)
	love.graphics.rotate(v.rot or 0)
	
	-- emit the render event
	event_handler.emit('render', v, ww, wh)
	
	-- store where the mouse position is based on the transformation of the view
	local mx, my = love.mouse.getPosition()
	local mx, my = love.graphics.inverseTransformPoint(mx, my)
	v.mx = mx v.my = my
	
	-- pop the graphics state 
	love.graphics.setCanvas()
	love.graphics.pop()
end
--- Draws all or the given view to the screen.
--- @param name string
--- @param ox number Offset on the x axis
--- @param oy number Offset on the y axis
--- @param ww number Width of the window
--- @param wh number Height of the window
function view.draw(name, ox, oy, ww, wh)
	-- draw all views if no view is given
	if not wh then
		for n, v in pairs(_view) do view.draw(n, name, ox, oy, ww) end
		return
	end
	
	-- draw the view's canvas to the screen based on the view's viewport
	local v = _view[name]
	if not v then print('Warning: no view with name '..name..' exists (in draw).') return end
	love.graphics.draw(v.canvas, ox + v.vx*ww, oy + v.vy*wh)
end


event_handler.subscribe('draw', function()
	local ww, wh = love.window.getMode()
	view.render(ww, wh)
	view.draw(0, 0, ww, wh)
end, 'view')


return view