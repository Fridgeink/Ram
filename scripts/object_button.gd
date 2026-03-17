extends Area2D
class_name ObjectButton

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Cursor"):
		print("worked")
		if Input.is_action_just_pressed("click"):
			SfxController.bump_noise()
