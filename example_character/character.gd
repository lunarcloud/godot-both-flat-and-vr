extends KinematicBody



##
## Example XR / Flat -Controlled Character
##
## @desc:
##     The script provides a simple example of a character controlled by the
##     input, and using the camera helpers from, "XrOrFlatMode" singleton.
##


enum Follow {
	SlideFlat,
	SlideBoth,
	RotateFlat,
	RotateBoth
}

export (float, 10.0, 60.0) var speed : float = 20.0

export (Follow) var FollowStyle := Follow.SlideBoth

var _velocity := Vector3.ZERO


func _physics_process(_delta):
	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(_velocity, Vector3.DOWN)

	match FollowStyle:
		Follow.SlideBoth:
			XrOrFlatMode.camera_slide_to(translation, Vector3(0, 10, 15), Vector3(0, 0, 30))
		Follow.SlideFlat:
			XrOrFlatMode.flat_camera_slide_to(translation, Vector3(0, 10, 15))
		Follow.RotateBoth:
			XrOrFlatMode.look_at(translation)
		Follow.RotateFlat:
			XrOrFlatMode.flat_look_at(translation)


func _process(_delta):
	# Get the input from the Singleton so it comes from the right source for the current mode
	var input := XrOrFlatMode.get_character_input()
	_velocity = speed * XrOrFlatMode.rotated_toward(Vector3(input.x, 0, input.y)).normalized()

