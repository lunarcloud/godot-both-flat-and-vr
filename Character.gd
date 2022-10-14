extends KinematicBody

export var speed := 20.0

var _speed_scale := 60.0

var _velocity := Vector3.ZERO

var last_input := Vector2.ZERO


func _physics_process(_delta):
	# Get the input from the Singleton so it comes from the right source for the current mode
	var input := XrMode.get_character_input()
	last_input = input
	var movement := Vector3(input.x, 0, input.y)
	movement = XrMode.rotated_to_camera_y(movement).normalized() * speed * _speed_scale

	# This is extremely important, as the 60 Hz normally seen flat,
	# won't match the typical 72, 90, or even 120 Hz of VR
	movement *= _delta

	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(movement, Vector3.DOWN)

func _process(_delta):
	XrMode.flat_camera_look_at(translation)

