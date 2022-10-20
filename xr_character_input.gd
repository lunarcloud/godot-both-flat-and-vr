tool
class_name XRModeCharacterInput, "res://addons/godot-xr-tools/editor/icons/function.svg"
extends Node

##
## XR Character Input
##
## The script provides a means to capture the input from XR controller and
## passes it along to the "XrOrFlatMode" singleton for use with a character.
##

# use enum from XRTools if they centralize these
enum Buttons {
	VR_BUTTON_BY = 1,
	VR_GRIP = 2,
	VR_BUTTON_3 = 3,
	VR_BUTTON_4 = 4,
	VR_BUTTON_5 = 5,
	VR_BUTTON_6 = 6,
	VR_BUTTON_AX = 7,
	VR_BUTTON_8 = 8,
	VR_BUTTON_9 = 9,
	VR_BUTTON_10 = 10,
	VR_BUTTON_11 = 11,
	VR_BUTTON_12 = 12,
	VR_BUTTON_13 = 13,
	VR_PAD = 14,
	VR_TRIGGER = 15
}

## Button to trigger jump
export(Buttons) var jump_button_id = Buttons.VR_BUTTON_AX

export var left_right_deadzone := 0.3

export var up_down_deadzone := 0.3

# Controller node
onready var _controller: ARVRController = get_parent()


func _ready():
	# If I don't handle end/begin events, replacing the headset stops character control

	# warning-ignore:return_value_discarded
	ARVRServer.connect("openxr_session_ending", self, "_on_xr_session_ending")
	# warning-ignore:return_value_discarded
	ARVRServer.connect("openxr_session_begun", self, "_on_xr_session_begun")


func _on_xr_session_ending():
	set_process(false)


func _on_xr_session_begun():
	set_process(true)


func _process(_delta):
	if Engine.editor_hint:
		return

	# Skip if the controller isn't active
	if !_controller.get_is_active():
		return

	# Read the left/right joystick axis
	var left_right: float = _controller.get_joystick_axis(0)
	if abs(left_right) <= left_right_deadzone:
		left_right = 0

	# Read the up/down joystick axis
	var up_down: float = _controller.get_joystick_axis(1) * -1  # flip vertical
	if abs(up_down) <= up_down_deadzone:
		up_down = 0

	var input := Vector2(left_right, up_down)
	XrOrFlatMode.xr_character_input = input


# This method verifies the movement provider has a valid configuration.
func _get_configuration_warning():
	# Check the controller node
	var test_controller = get_parent()
	if !test_controller or !test_controller is ARVRController:
		return "Unable to find ARVR Controller node"

	# Passed validation
	return ""
