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

	var displaysAsXr = arguments.get("xr", "false") == "true" \
		or OS.has_feature("always-xr")

	print("XR Mode Active" if displaysAsXr else "Standard Non-XR Mode Active")

	get_tree().change_scene(
		"res://VrView.tscn" if displaysAsXr else "res://FlatView.tscn"
	)


