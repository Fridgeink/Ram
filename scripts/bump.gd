extends Area2D

func _on_mouse_entered() -> void:
	if Input.is_action_pressed("click"):
		SfxController.bump_noise()
