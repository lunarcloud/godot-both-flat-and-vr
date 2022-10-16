extends Spatial

var _offset := Vector3.ZERO

func _ready():
	_offset = global_translation - XrOrFlatMode._get_xr_origin().global_translation


func _process(delta):
	# Keep the original X/Z offset
	global_translation = XrOrFlatMode._get_xr_origin().global_translation + _offset

	# Apply the player height Y
	translation.y = XrOrFlatMode.xr_player_height()
