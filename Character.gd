extends KinematicBody

export var speed := 20.0

var _velocity := Vector3.ZERO

onready var _camera: Camera = get_viewport().get_camera()

func _physics_process(delta):
	var input := Input.get_vector(	"character_left", 		"character_right",
									"character_forward", 	"character_backward",
									0.3)
	var movement := Vector3(input.x, 0, input.y)
	movement = movement.rotated(Vector3.UP, _camera.rotation.y).normalized()
	movement *= speed

	move_and_slide_with_snap(movement, Vector3.DOWN)

func _process(delta):
	if not _camera is ARVRCamera:
		_camera.look_at(translation, Vector3.UP)
