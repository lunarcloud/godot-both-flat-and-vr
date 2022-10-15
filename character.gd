extends KinematicBody

export var speed := 20.0

var _velocity := Vector3.ZERO


func _physics_process(_delta):
	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(_velocity, Vector3.DOWN)
	XrMode.camera_slide_to(translation, Vector3(0, 10, 15), Vector3(0, 0, 30))


func _process(_delta):
	# Get the input from the Singleton so it comes from the right source for the current mode
	var input := XrMode.get_character_input()
	_velocity = XrMode.rotated_to_camera_y(Vector3(input.x, 0, input.y)).normalized() \
				* speed

