extends AnimatedSprite3D

enum Frames {
	LOWER_CENTER = 0,
	LOWER_LEFT = 1,
	LOWER_RIGHT = 2,
	MID_CENTER = 3,
	MID_LEFT = 4,
	MID_RIGHT = 5,
	UPPER_CENTER = 6,
	UPPER_LEFT = 7,
	UPPER_RIGHT = 8
}

# Controller node
onready var _character_input : XRModeCharacterInput = get_parent().get_node("XRModeCharacterInput")


func _ready():
	pause_mode = true
	frame = Frames.MID_CENTER

	_character_input.connect("input_updated", self, "_input_updated")


# Quickly convert the X/Y input values to the correct frame
func _input_updated(input: Vector2) -> void:
	var displayed_frame = 0

	if input.y < -1 * _character_input.up_down_deadzone:
		displayed_frame += 6
	elif input.y == 0:
		displayed_frame += 3

	if input.x > _character_input.left_right_deadzone:
		displayed_frame += 2
	elif input.x < -1 * _character_input.left_right_deadzone:
		displayed_frame += 1

	frame = displayed_frame


# This method verifies the movement provider has a valid configuration.
func _get_configuration_warning():
	# Check the controller node
	var test_character_input = get_parent().get_node("XRModeCharacterInput")
	if !test_character_input or !test_character_input is XRModeCharacterInput:
		return "Unable to find XR Mode Character Input node"

	# Passed validation
	return ""
