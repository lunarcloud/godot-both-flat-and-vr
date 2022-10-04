extends Node

func _ready():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			# Options without an argument
			arguments[argument.lstrip("--")] = "true"

	# if we didn't specify or force, stop here and use UI selector
	if not OS.has_feature("always-xr") \
		and not arguments.has("xr") and not arguments.has("flat"):
		print("No command-line mode argument provided, providing selector UI.")
		return

	# if forced, use XR mode
	if OS.has_feature("always-xr"):
		print("Mode is baked into the build...")
		launch_xr()
		return

	print("Using command-line arguments to determine mode...")
	if arguments.get("xr") == "true"  or arguments.get("flat") == "true":
		launch_xr()
	else:
		launch_flat()


func launch_xr() -> void:
	print("XR Mode Active")
	get_tree().change_scene("res://VrView.tscn")


func launch_flat() -> void:
	print("Standard Non-XR Mode Active")
	get_tree().change_scene("res://FlatView.tscn")
