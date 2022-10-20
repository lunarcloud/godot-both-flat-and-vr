extends Node

##
## XR / Flat Mode Autoload Singleton
##
## The script provides a means for the "What mode are we in" question
## to be asked from anywhere. Expected to use a Node name of "XrOrFlatMode".
##

# The Two Modes supported
enum Mode { XR, FLAT }

# Current Mode (XR / Flat)
var current_mode = Mode.FLAT setget _on_mode_set

# Cache of character input value from the XrCharacterInput script
var xr_character_input := Vector2.ZERO

# This is a workaround for sometimes the XR stage not being aligned with the initial camera rotation
var xr_y_rotation_correction: float = 0

# Cache of the active camera
var _camera: Camera

# Cache of the active XR Origin
var _xr_origin: ARVROrigin

# Cache of the XrCharacterInput's Controller, for vibration
var _get_character_input_controller: ARVRController


# Setter for "current_mode", ensures XR Server event subscribing
func _on_mode_set(value):
	if value == Mode.XR:
		# warning-ignore:return_value_discarded
		ARVRServer.connect("openxr_session_exiting", self, "_on_xr_session_exiting")
	current_mode = value


# Close the App when the session ends
func _on_xr_session_exiting():
	print("Exiting with XR session")
	get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)


# Return input from the normal input or the XRCharacterInput script & variable
func get_character_input() -> Vector2:
	if current_mode == Mode.XR:
		return xr_character_input

	# Technically, this code works in XR, but produces undesired results
	return Input.get_vector(
		"character_left", "character_right", "character_forward", "character_backward", 0.3
	)


# Get the camera
func _get_camera() -> Camera:
	if !is_instance_valid(_camera):
		_camera = get_viewport().get_camera()
	return _camera


# Get the XR Origin
func get_xr_origin() -> ARVROrigin:
	if current_mode == Mode.FLAT:
		return null

	if !is_instance_valid(_xr_origin):
		var camera = _get_camera()
		if camera is ARVRCamera:
			_xr_origin = _get_camera().get_parent()

	return _xr_origin


# Rotate Flat Camera (no XR) to look at target
func flat_look_at(target: Vector3):
	if current_mode == Mode.FLAT:
		_get_camera().look_at(target, Vector3.UP)


# Slide the Flat Camera or XR Origin to follow target with offset
func camera_slide_to(target: Vector3, flat_offset: Vector3, xr_offset: Vector3):
	if current_mode == Mode.FLAT:
		return flat_camera_slide_to(target, flat_offset)
	# else XR
	var new_position = target + xr_offset
	get_xr_origin().global_transform.origin.x = new_position.x
	get_xr_origin().global_transform.origin.z = new_position.z


# Slide the Flat Camera (no XR) to follow target with offset
func flat_camera_slide_to(target: Vector3, offset: Vector3):
	_get_camera().global_transform.origin = target + offset
	_get_camera().look_at(target, Vector3.UP)


# Rotate the Flat Camera or XR Origin to follow target
func rotated_toward(target: Vector3) -> Vector3:
	var reference_y: float = 0
	if current_mode == Mode.XR:
		reference_y = get_xr_origin().global_rotation.y + xr_y_rotation_correction
	else:
		reference_y = _get_camera().global_rotation.y
	return target.rotated(Vector3.UP, reference_y)


func xr_player_height() -> float:
	return _get_camera().translation.y


func vibrate(weak_magnitude: float, strong_magnitude: float, duration: float) -> void:
	if current_mode == Mode.FLAT:
		Input.start_joy_vibration(0, weak_magnitude, strong_magnitude, duration)
	else:  #XR
		var controller: ARVRController = _get_character_input_controller()
		var strong_amount := clamp(strong_magnitude / 2, 0.0, 0.5)
		if strong_amount > 0.0:
			controller.rumble = strong_amount
		else:  # weak amount
			controller.rumble = clamp(weak_magnitude / 2, 0.0, 0.5)

		yield(get_tree().create_timer(duration), "timeout")
		controller.rumble = 0.0


func _get_character_input_controller() -> ARVRController:
	if is_instance_valid(_get_character_input_controller):
		return _get_character_input_controller

	# See if the right controller has the XRModeCharacterInput, else assume left
	var right: ARVRController = ARVRHelpers.get_right_controller(get_xr_origin())
	var xr_character_input = right.get_node_or_null("XRModeCharacterInput") as XRModeCharacterInput
	if xr_character_input:
		_get_character_input_controller = right
	else:
		_get_character_input_controller = ARVRHelpers.get_left_controller(get_xr_origin())
	return _get_character_input_controller
