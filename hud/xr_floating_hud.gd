extends Spatial

##
## XR Floating HUD
##
## The script ensures the HUD stays relative to the XR player's height.
##

var _offset := Vector3.ZERO


func _ready():
	_offset = global_translation - XrOrFlatMode.get_xr_origin().global_translation


func _process(_delta):
	# Keep the original X/Z offset
	global_translation = XrOrFlatMode.get_xr_origin().global_translation + _offset

	# Apply the player height Y
	translation.y = XrOrFlatMode.xr_player_height()
