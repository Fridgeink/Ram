extends Control

@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("tut1")
	
	await get_tree().process_frame
	Global.current_scene = str(get_tree().current_scene.scene_file_path)
