extends KinematicBody

##
## Example XR / Flat -Controlled Character
##
## The script provides a simple example of a character controlled by the
## input, and using the camera helpers from, "XrOrFlatMode" singleton.
##

enum Follow { NEITHER, FLAT, BOTH }

export(float, 10.0, 60.0) var speed: float = 8.0

export(Follow) var follow_style := Follow.BOTH

export(float, 0.01, 1.0) var bump_vibrate = 0.75

var _velocity := Vector3.ZERO

# remember if we were last frame touching a wall - true by default to prevent an initial rumble
var _was_on_wall := true

onready var _anim = $AnimationPlayer


func _physics_process(_delta):
	if _velocity != Vector3.ZERO:
		# warning-ignore:return_value_discarded
		move_and_slide_with_snap(_velocity, Vector3.DOWN)

	match follow_style:
		Follow.BOTH:
			XrOrFlatMode.camera_slide_to(translation, Vector3(0, 4.5, 5), Vector3(0, 0, 7.5))
		Follow.FLAT:
			XrOrFlatMode.flat_camera_slide_to(translation, Vector3(0, 4.5, 5))


func _process(_delta):
	_process_vibration()

	# Get the input from the Singleton so it comes from the right source for the current mode
	var input := XrOrFlatMode.get_character_input()
	var direction := Vector3(input.x, 0, input.y).normalized()
	direction = XrOrFlatMode.rotated_toward(direction)
	_velocity = speed * direction
	_process_animation()


func _process_animation():
	if _velocity == Vector3.ZERO and _anim.is_playing():
		_anim.play("RESET")
		return
	if _velocity != Vector3.ZERO and not _anim.current_animation == "Walking":
		_anim.play("Walking")


func _process_vibration():
	if _velocity == Vector3.ZERO:
		return
	if is_on_wall() and not _was_on_wall:
		XrOrFlatMode.vibrate(bump_vibrate, 0.0, 0.1)
	_was_on_wall = is_on_wall()
