

-- General
function love.load(arg, unfilteredArg)
	
	utf8 = require'utf8'
	bitops = require'bit'
	utils = require'utils'
	
	event_handler = require'event_handler'
	resources = require'resources'
	ecs = require'ecs'
	
	ecs.initialise()
	resources.initialise()
	
	resources.loadSheet('tile')
	
end
function love.update(dt)
	
	ecs.update(dt)
	resources.update()
	
	event_handler.emit('update', dt)
	
end
function love.draw()
	
	event_handler.emit('draw')
	
end
function love.quit()
	
end
function love.threaderror(thread, errorstr)
	
end

-- Window
function love.directorydropped(path)
	
end
function love.filedropped(file)
	
end
function love.focus(focus)
	
end
function love.mousefocus(focus)
	
end
function love.resize(w, h)
	
end
function love.visible(visible)
	
end

-- Keyboard
function love.keypressed(key, scancode, isrepeat)
	
	event_handler.emit('keypressed', key, scancode, isrepeat)
	
end
function love.keyreleased(key, scancode)
	
	event_handler.emit('keyreleased', key, scancode)
	
end
function love.textinput(text)
	
end

-- Mouse
function love.mousemoved(x, y, dx, dy, istouch)
	
	event_handler.emit('mousemoved', x, y, dx, dy, istouch)
	
end
function love.mousepressed(x, y, button, istouch, presses)
	
	event_handler.emit('mousepressed', x, y, button, istouch, presses)
	
end
function love.mousereleased(x, y, button, istouch, presses)
	
	event_handler.emit('mousereleased', x, y, button, istouch, presses)
	
end
function love.wheelmoved(x, y)
	
	event_handler.emit('wheelmoved', x, y)
	
end

-- Joystick
function love.gamepadaxis(joystick, axis, value)
	
end
function love.gamepadpressed(joystick, button)
	
end
function love.gamepadreleased(joystick, button)
	
end
function love.joystickadded(joystick)
	
end
function love.joystickaxis(joystick, axis, value)
	
end
function love.joystickhat(joystick, hat, direction)
	
end
function love.joystickpressed(joystick, button)
	
end
function love.joystickreleased(joystick, button)
	
end
function love.joystickremoved(joystick)
	
end

