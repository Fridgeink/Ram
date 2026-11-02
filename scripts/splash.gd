extends Control

@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String = "start_menu"
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Global.title = "I hate this guy"
	SfxController.reveal_noise()
	transition.on()

func _on_animation_finished(_anim_name: StringName) -> void:
	transition.off()
