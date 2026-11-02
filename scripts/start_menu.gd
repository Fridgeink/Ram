extends CanvasLayer

@onready var start: Button = $Buttons/Start
@onready var exit: Button = $Buttons/Exit
@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String = "tutorial"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.title = "Randomly Accessing Memories..."
	transition.on()
	SfxController.hum_noise()
	if AudioController.active_playlist != "title":
		AudioController.play_playlist("title")
	if Global.intro_done:
		next_scene = "main_menu"
	await get_tree().process_frame
	Global.current_scene = str(get_tree().current_scene.scene_file_path)

func _on_start_pressed() -> void:
	Global.reset_prog()
	AudioController._pause_current_song()
	transition.off()

func _on_exit_pressed() -> void:
	get_tree().quit()
