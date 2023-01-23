extends ARVROrigin


export var near_z = 0.1
export var far_z = 1000.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$ARVRCamera.near = near_z
	$ARVRCamera.far = far_z

