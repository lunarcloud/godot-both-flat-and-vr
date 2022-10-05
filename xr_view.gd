extends Node

# Close the App when the session ends
func _on_FPController_session_ending():
	print("Exiting with XR session")
	get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)
