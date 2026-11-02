extends CanvasLayer

@onready var progress_label: RichTextLabel = $ProgressLabel
var next := Global.loading
var scene_load_status

func _ready() -> void:
	Global.title = ""
	load_next()

func load_next():
	ResourceLoader.load_threaded_request(next)

func _process(_delta: float) -> void:
	var progress := []
	scene_load_status = ResourceLoader.load_threaded_get_status(next, progress)
	if progress.size() > 0:
		progress_label.text = str(floor(progress[0] * 100)) + "%"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var next_scene := ResourceLoader.load_threaded_get(next)
		await get_tree().process_frame
		get_tree().change_scene_to_packed(next_scene)
