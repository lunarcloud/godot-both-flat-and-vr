extends KinematicBody



##
## Example XR / Flat -Controlled Character
##
## @desc:
##     The script provides a simple example of a character controlled by the
##     input, and using the camera helpers from, "XrOrFlatMode" singleton.
##


enum Follow {
	Flat,
	Both,
	Neither
}

export (float, 10.0, 60.0) var speed : float = 8.0

export (Follow) var FollowStyle := Follow.Both

export (float, 0.01, 1.0) var bump_vibrate = 0.75

var _velocity := Vector3.ZERO

var _was_on_wall := false

func _physics_process(_delta):
	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(_velocity, Vector3.DOWN)

	match FollowStyle:
		Follow.Both:
			XrOrFlatMode.camera_slide_to(translation, Vector3(0, 4.5, 5), Vector3(0, 0, 7.5))
		Follow.Flat:
			XrOrFlatMode.flat_camera_slide_to(translation, Vector3(0, 4.5, 5))


func _process(_delta):
	_process_vibration()

	# Get the input from the Singleton so it comes from the right source for the current mode
	var input := XrOrFlatMode.get_character_input()
	var direction := Vector3(input.x, 0, input.y).normalized()
	direction = XrOrFlatMode.rotated_toward(direction)
	_velocity = speed * direction


func _process_vibration():
	if is_on_wall() and not _was_on_wall:
		XrOrFlatMode.vibrate(bump_vibrate, 0.0, 0.1)
	_was_on_wall = is_on_wall()
