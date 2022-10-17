extends Node



##
## XR / Flat Mode Autoload Singleton
##
## @desc:
##     The script provides a means for the "What mode are we in" question
##     to be asked from anywhere. Expected to use a Node name of "XrOrFlatMode".
##


# The Two Modes supported
enum Mode {
	XR,
	Flat
}

# Shorthands "Mode.Flat" to simplify code
var Flat = Mode.Flat

# Shorthands "Mode.XR" to simplify code
var XR = Mode.XR

# Current Mode (XR / Flat)
var CurrentMode = Mode.Flat setget _on_mode_set

# Cache of character Input value from the XrCharacterInput script
var XrCharacterInput := Vector2.ZERO

# Cache of the active camera
var _camera : Camera

# Cache of the active XR Origin
var _xr_origin : ARVROrigin

# This is a workaround for sometimes the XR stage not being aligned with the initial camera rotation
var XrRotationYCorrection : float = 0

# Setter for "CurrentMode", ensures XR Server event subscribing
func _on_mode_set(value):
	if value == XR:
		# warning-ignore:return_value_discarded
		ARVRServer.connect("openxr_session_exiting", self, "_on_xr_session_exiting")
	CurrentMode = value


# Close the App when the session ends
func _on_xr_session_exiting():
	print("Exiting with XR session")
	get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)


# Return input from the normal input or the XRCharacterInput script & variable
func get_character_input() -> Vector2:
	if CurrentMode == XR:
		return XrCharacterInput

	# Technically, this code works in XR, but produces undesired results
	return Input.get_vector("character_left", 	 "character_right",
							"character_forward", "character_backward",
							0.3)


# Get the camera
func _get_camera() -> Camera:
	if !is_instance_valid(_camera):
		_camera = get_viewport().get_camera()
	return _camera


# Get the XR Origin
func _get_xr_origin() -> ARVROrigin:
	if CurrentMode == Flat:
		return null

	if !is_instance_valid(_xr_origin):
		var camera = _get_camera()
		if camera is ARVRCamera:
			_xr_origin = _get_camera().get_parent()

	return _xr_origin


# Rotate Flat Camera (no XR) to look at target
func flat_look_at(target: Vector3):
	if CurrentMode == Flat:
		_get_camera().look_at(target, Vector3.UP)


# Slide the Flat Camera or XR Origin to follow target with offset
func camera_slide_to(target: Vector3, flat_offset: Vector3, xr_offset: Vector3):
	if CurrentMode == Flat:
		return flat_camera_slide_to(target, flat_offset)
	# else XR
	var new_position = target + xr_offset
	_get_xr_origin().global_transform.origin.x = new_position.x
	_get_xr_origin().global_transform.origin.z = new_position.z


# Slide the Flat Camera (no XR) to follow target with offset
func flat_camera_slide_to(target: Vector3, offset: Vector3):
	_get_camera().global_transform.origin = target + offset
	_get_camera().look_at(target, Vector3.UP)


# Rotate the Flat Camera or XR Origin to follow target
func rotated_toward(target: Vector3) -> Vector3:
	var reference_y : float = 0
	if CurrentMode == XR:
		reference_y = _get_xr_origin().global_rotation.y + XrRotationYCorrection
	else:
		reference_y = _get_camera().global_rotation.y
	return target.rotated(Vector3.UP, reference_y)


func xr_player_height() -> float:
	return _get_camera().translation.y
