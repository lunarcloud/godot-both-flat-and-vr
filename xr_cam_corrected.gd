class_name CorrectedARVRCamera
extends ARVRCamera



##
## XR Stage/Camera Rotation Mis-Match Correction Script
##
## @desc:
##     This whole script is a workaround for sometimes the XR stage not
##      being aligned with the initial camera rotation
##


var _last_rotation := Vector3.ZERO

var _correction_applied := false


func _process(delta):
	if _last_rotation != Vector3.ZERO and not _correction_applied:
		var rotationY = global_rotation.y

		# Rotate towards where the Origin node is pointing
		get_parent().global_rotation.y -= rotationY

		# Inform the Singleton of the offset applied
		XrOrFlatMode.XrRotationYCorrection = rotationY

		# Never Run this code for the life of this XR Camera
		_correction_applied = true
		set_process(false)

	_last_rotation = global_rotation

