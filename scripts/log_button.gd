extends Area2D

@export var enabled: bool = true
@onready var next_scene: String = str(name).to_lower()

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area_name = str(name).to_lower()
@onready var parent := get_node("../..")

var hovered: bool = false

func _input(event: InputEvent) -> void:
	if not enabled:
		return

	if event.is_action_pressed("click") and hovered:
		CursorManager.hover = false
		anim.play("done")

func _on_mouse_entered() -> void:
	if not enabled:
		return
	CursorManager.hover = true
	hovered = true
	SfxController.clang_noise()

func _on_mouse_exited() -> void:
	if not enabled:
		return
	CursorManager.hover = false
	hovered = false

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "done":
		parent.next_scene = next_scene
		await get_tree().create_timer(0.8).timeout
		parent.transition.off()
