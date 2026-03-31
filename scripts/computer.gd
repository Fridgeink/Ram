extends Control

@onready var transition: CanvasLayer = $SceneTransition
@onready var timer: Control = $Timer
@onready var button_sprite: Sprite2D = $Button/Sprite2D
@onready var next_scene: String = "ending"
@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("RESET")
	if AudioController.active_playlist != "computer":
		AudioController.play_playlist("computer")

	Dialogic.start("computer1")
	await Dialogic.timeline_ended
	anim.play("fade")

	await get_tree().process_frame
	Global.current_scene = str(get_tree().current_scene.scene_file_path)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		$Button/Button.enabled = true
		timer.show()
		timer.start_timing()

func button_press() -> void:
	Global.button_pressed = true
	timer.enabled = false
	timer.hide()
	AudioController.play_playlist("reset")
	button_sprite.hide()
	await get_tree().create_timer(1.3).timeout
	transition.off()
