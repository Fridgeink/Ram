extends Control

@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String

@onready var logs_container = $Logs
@onready var pda: Area2D = $Pda/Pda
@onready var anim: AnimationPlayer = $AnimationPlayer

var logs: Array = []

func _ready() -> void:
	Global.title = ""
	transition.on()
	Dialogic.VAR.next = false
	if AudioController.active_playlist != "reset":
		AudioController.play_playlist("reset")
	
	if not Global.intro_done:
		Dialogic.start("tut1")
		await Dialogic.timeline_ended

	await get_tree().process_frame
	Global.current_scene = str(get_tree().current_scene.scene_file_path)
	if pda.enabled and Global.logs_complete < 4:
		pda.enabled = false
	# Get all logs dynamically
	logs = logs_container.get_children()

	# update logs AFTER dialogue
	if Global.logs_complete < 4:
		update_logs()
	else:
		show_pda()

func _process(_delta: float) -> void:
	if Dialogic.VAR.box:
		logs_container.hide()
	else:
		logs_container.show()

func update_logs() -> void:
	pda.enabled = false
	anim.play("RESET")

	var active = clamp(Global.logs_complete, 0, logs.size() - 1)

	for i in range(logs.size()):
		var mlog = logs[i]
		if i == active:
			mlog.enabled = true
		else:
			mlog.enabled = false
			mlog.anim.play("RESET")

	await get_tree().create_timer(60).timeout
	if not is_instance_valid(self):
		return

	logs[active].anim.play("fade")

func show_pda() -> void:
	pda.enabled = true
	anim.play("pda_fade")
	for i in range(logs.size()):
		var mlog = logs[i]
		mlog.enabled = false
		mlog.anim.play("RESET")
