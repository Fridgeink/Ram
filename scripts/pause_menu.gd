extends Node

var pause_menu: PackedScene
var is_paused: bool = false
var pause_menu_instance: Node = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu = preload("res://scenes/pause_menu.tscn")

func _input(event: InputEvent):
	if event.is_action_pressed("pause") and not Dialogic.VAR.box:
		if is_paused:
			_on_resume_pressed()
		else:
			show_pause_menu()

func show_pause_menu():
	self.visible = true
	AudioController._pause_current_song()
	is_paused = true

	if is_instance_valid(pause_menu_instance):
		return


	Global.currently_paused = true
	pause_menu_instance = pause_menu.instantiate()
	get_tree().root.add_child(pause_menu_instance)

	if get_tree() and !get_tree().paused:
		get_tree().paused = true

	var resume_button := pause_menu_instance.get_node("Buttons/Resume")
	var quit_button := pause_menu_instance.get_node("Buttons/Exit")

	resume_button.grab_focus()
	resume_button.connect("pressed", Callable(self, "_on_resume_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))


func _on_resume_pressed():
	resume_game()

func _on_quit_pressed():
	quit()

func resume_game():
	# Always check if still inside the tree before using get_tree()
	if not is_inside_tree():
		return
	
	AudioController.play_playlist(AudioController.active_playlist)
	is_paused = false
	Global.currently_paused = false

	if get_tree() and get_tree().paused:
		get_tree().paused = false

	if pause_menu_instance != null:
		if is_instance_valid(pause_menu_instance):
			pause_menu_instance.queue_free()
		pause_menu_instance = null
	self.visible = false


func quit():
	is_paused = false
	Global.currently_paused = false
	AudioController.resume_previous_playlist()

	if get_tree() and get_tree().paused:
		get_tree().paused = false
	if pause_menu_instance != null:
		pause_menu_instance.queue_free()
		pause_menu_instance = null

	if get_tree():
		if Global.current_scene == "res://scenes/main_menu.tscn":
			get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _exit_tree():
	if pause_menu_instance != null:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
