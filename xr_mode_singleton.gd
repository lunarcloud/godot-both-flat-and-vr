extends Node



##
## XR / Flat Mode Autoload Singleton
##
## @desc:
##     The script provides a means for the "What mode are we in" question
##     to be asked from anywhere. Expected to use a Node name of "XrMode".
##


enum Mode {
	XR,
	Flat
}

# Shorthands to simplify code
var Flat = Mode.Flat
var XR = Mode.XR

export var CurrentMode := Mode.Flat setget _on_mode_set

var _camera : Camera
var _xr_origin : ARVROrigin
var XrCharacterInput := Vector2.ZERO

func _on_mode_set(value):
	if value == XR:
		# warning-ignore:return_value_discarded
		ARVRServer.connect("openxr_session_exiting", self, "_on_xr_session_exiting")
	CurrentMode = value

# Close the App when the session ends
func _on_xr_session_exiting():
	print("Exiting with XR session")
	get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)


func get_character_input() -> Vector2:
	if XrMode.CurrentMode == XrMode.XR:
		return XrCharacterInput

	# Technically, this code works in XR, but produces undesired results
	return Input.get_vector(	"character_left", 		"character_right",
								"character_forward", 	"character_backward",
								0.3)


func _get_camera() -> Camera:
	if !is_instance_valid(_camera):
		_camera = get_viewport().get_camera()
	return _camera

func _get_xr_origin() -> ARVROrigin:
	if XrMode.CurrentMode == XrMode.Flat:
		return null

	if !is_instance_valid(_xr_origin):
		var camera = _get_camera()
		if camera is ARVRCamera:
			_xr_origin = _get_camera().get_parent()

	return _xr_origin


func flat_camera_look_at(target: Vector3):
	if XrMode.CurrentMode == XrMode.XR:
		return
	_get_camera().look_at(target, Vector3.UP)


func rotated_to_camera_y(target: Vector3) -> Vector3:
	var reference_y = _get_xr_origin().rotation.y \
					 if XrMode.CurrentMode == XrMode.XR else \
					 _get_camera().rotation.y
	return target.rotated(Vector3.UP, reference_y)

