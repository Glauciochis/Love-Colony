local input_control = {}
input_control.current_control_type = 0
input_control.CONTROL_TYPE = { none = 0, mouse_keyboard = 1, gamepad = 2 }
input_control.INPUT_TYPE = { button = 1, axis = 2, vector = 3 }
input_control.inputs = {
	horizontal = {
		type = input_control.INPUT_TYPE.axis
		,positive = {
			gamepadpresses={ 'dpright' }
			,keyboard={ 'right', 'd' }
		}
		,negative = {
			gamepadpresses={ 'dpleft' }
			,keyboard={ 'left', 'a' }
		}
		,axis = {
			gamepadaxis={ deadzone=0.255, 'leftx' }
		}
	}
	,vertical = {
		type = input_control.INPUT_TYPE.axis
		,positive = {
			gamepadpresses={ 'dpdown' }
			,keyboard={ 'down', 's' }
		}
		,negative = {
			gamepadpresses={ 'dpup' }
			,keyboard={ 'up', 'w' }
		}
		,axis = {
			gamepadaxis={ deadzone=0.255, 'lefty' }
		}
	}
}
input_control.input_triggers = {
	mouse_presses = { [1]='confirm', [2]='deny' }
	,mouse_scrolls = {}
	,mouse_moves = {}
	,keyboard_presses = {}
	,gamepad_presses = { a='confirm', b='deny' }
}


function input_control.initialise()
	input_control.current_control_type = input_control.CONTROL_TYPE.none
end

-- mouse
function input_control.mousepressed(x, y, button, istouch, presses)
	input_control.current_control_type = input_control.CONTROL_TYPE.mouse_keyboard
end
function input_control.mousereleased(x, y, button, istouch, presses)
	input_control.current_control_type = input_control.CONTROL_TYPE.mouse_keyboard
end
function input_control.mousemoved(x, y, dx, dy, istouch)
	
end
function input_control.wheelmoved(x, y)
	input_control.current_control_type = input_control.CONTROL_TYPE.mouse_keyboard
end

-- keyboard
function input_control.keypressed(key, scancode, isrepeat)
	input_control.current_control_type = input_control.CONTROL_TYPE.mouse_keyboard
end
function input_control.keyreleased(key, scancode)
	input_control.current_control_type = input_control.CONTROL_TYPE.mouse_keyboard
end
function input.control.textinput(text)
	input_control.current_control_type = input_control.CONTROL_TYPE.mouse_keyboard
end

-- gamepad/joystick
function input_control.gamepadpressed(joystick, button)
	input_control.current_control_type = input_control.CONTROL_TYPE.gamepad
end
function input_control.gamepadreleased(joystick, button)
	input_control.current_control_type = input_control.CONTROL_TYPE.gamepad
end
function input_control.gamepadaxis(joystick, axis, value)
	input_control.current_control_type = input_control.CONTROL_TYPE.gamepad
end


return input_control