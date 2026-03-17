extends CanvasLayer

@onready var start: Button = $Buttons/Start
@onready var exit: Button = $Buttons/Exit
@onready var transition: CanvasLayer = $SceneTransition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SfxController.hum_noise()
	if AudioController.active_playlist != "title":
		AudioController.play_playlist("title")
	await get_tree().process_frame
	AudioController.play_playlist("title")

func _on_start_pressed() -> void:
	AudioController._pause_current_song()
	transition.off()

func _on_exit_pressed() -> void:
	get_tree().quit()

func next() -> void:
	Global.loading = "res://scenes/main_menu.tscn"
	var loading_screen = load("res://scenes/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)
