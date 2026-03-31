extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var chip: InteractableArea = $Chip/Chip
@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String = "main_menu"

var changing: bool = false

func _ready() -> void:
	transition.on()
	Dialogic.VAR.next = false
	AudioController._pause_current_song()
	anim.play("RESET")
	Dialogic.start("huh")
	await get_tree().process_frame
	Global.current_scene = str(get_tree().current_scene.scene_file_path)

func _process(_delta: float) -> void:
	if Dialogic.VAR.next and not changing:
		changing = true
		anim.play("fade")
		chip.enabled = true


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "done":
		await get_tree().create_timer(1.8).timeout
		transition.off()
