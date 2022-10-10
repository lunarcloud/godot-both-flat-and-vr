extends Node

# Close the App when the session ends
func _on_xr_session_exiting():
	print("Exiting with XR session")
	get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)


