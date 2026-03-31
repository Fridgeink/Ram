extends Control

@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String = "start_menu"
@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SfxController.reveal_noise()
	transition.on()

func _on_animation_finished(_anim_name: StringName) -> void:
	transition.off()
