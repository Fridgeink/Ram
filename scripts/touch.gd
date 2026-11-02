extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		# Map touch press/release to a left mouse button event
		var mouse_button = InputEventMouseButton.new()
		mouse_button.pressed = event.pressed
		mouse_button.button_index = MOUSE_BUTTON_LEFT
		mouse_button.position = event.position
		mouse_button.global_position = event.global_position
		Input.parse_input_event(mouse_button)
		
	elif event is InputEventScreenDrag:
		# Map touch movement directly to mouse motion
		var mouse_motion = InputEventMouseMotion.new()
		mouse_motion.position = event.position
		mouse_motion.global_position = event.global_position
		mouse_motion.relative = event.relative
		Input.parse_input_event(mouse_motion)
