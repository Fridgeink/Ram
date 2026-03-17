extends CanvasLayer

func _ready():
	preload_all_timelines("res://timelines/")

func preload_all_timelines(path: String):
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Failed to open timeline directory at: " + path)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".dtl"):
			var file_path := path + file_name
			var timeline_resource := ResourceLoader.load(file_path)
			if timeline_resource:
				Dialogic.preload_timeline(timeline_resource)
			else:
				push_error("Failed to load timeline: " + file_path)
		file_name = dir.get_next()
	dir.list_dir_end()
