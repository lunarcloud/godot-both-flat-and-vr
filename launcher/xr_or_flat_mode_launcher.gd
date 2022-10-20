class_name XrOrFlatModeLauncher
extends Node

##
## XR / Flat Mode Game Launcher
##
## The script launches the game in either flat or xr modes based on
## either features added to the export options, command-line arguments,
## or autodetected based on whether the XR interface can be started,
## i.e. if a VR headset is connected or not.
##


func _ready():
	if _check_os_features():
		return
	if _check_args():
		return
	_autodetect()


# Handle launch if provided one of the 3 OS features that can be added
func _check_os_features() -> bool:
	# if forced to use this selector UI, early-return
	if OS.has_feature("in-engine-mode-selector"):
		return true

	# if forced, use XR mode
	if OS.has_feature("always-xr"):
		print("Mode is baked into the build...")
		launch_xr()
		return true

	# if forced, use Non-XR mode
	if OS.has_feature("never-xr") or OS.has_feature("always-flat"):
		print("Mode is baked into the build...")
		launch_flat()
		return true

	return false


# Handle launch if provided one of the two cli args that can be used
func _check_args() -> bool:
	# read CLI arguments
	var arguments = {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			# Options without an argument
			arguments[argument.lstrip("--")] = "true"

	# if explicitly chose XR mode
	if arguments.get("xr") == "true" or arguments.get("flat") == "false":
		print("Using command-line arguments to determine mode...")
		launch_xr()
		return true

	# if explicitly chose Non-XR mode
	if arguments.get("xr") == "false" or arguments.get("flat") == "true":
		print("Using command-line arguments to determine mode...")
		launch_flat()
		return true

	return false


# Launch XR if it can be initialized, otherwise launch flat
func _autodetect() -> void:
	# if we didn't specify, autodetect
	print("Autodetecting XR or non-XR mode on whether a headset is connected...")
	var xr_interface := ARVRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.initialize():
		launch_xr()
	else:
		launch_flat()


# Launch the XR scene
func launch_xr() -> void:
	print("XR Mode Active")
	XrOrFlatMode.current_mode = XrOrFlatMode.Mode.XR
	if get_tree().change_scene("res://example_level/xr.tscn") != OK:
		print("Failed to load initial scene, quitting...")
		get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)


# Launch the Flat Scene
func launch_flat() -> void:
	print("Standard Non-XR Mode Active")
	XrOrFlatMode.current_mode = XrOrFlatMode.Mode.FLAT
	if get_tree().change_scene("res://example_level/flat.tscn") != OK:
		print("Failed to load initial scene, quitting...")
		get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)
