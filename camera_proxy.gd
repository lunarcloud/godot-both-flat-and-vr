extends RemoteTransform

func _ready():
	var camera: Camera = get_viewport().get_camera()

	set_as_toplevel(true)
	remote_path = camera.get_path()
