extends Control

@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String

@onready var logs_container = $Logs
@onready var pda: Area2D = $Pda/Pda
@onready var anim: AnimationPlayer = $AnimationPlayer

var logs: Array = []

func _ready() -> void:
	transition.on()
	Dialogic.VAR.next = false
	if AudioController.active_playlist != "reset":
		AudioController.play_playlist("reset")
	
	if not Global.intro_done:
		Dialogic.start("tut1")
		await Dialogic.timeline_ended

	await get_tree().process_frame
	Global.current_scene = str(get_tree().current_scene.scene_file_path)

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
	for i in range(logs.size()):
		var mlog = logs[i]

		if i == clamp(Global.logs_complete, 0, logs.size() - 1):
			mlog.enabled = true
			mlog.anim.play("fade") # active one fades in
		else:
			mlog.enabled = false
			mlog.anim.play("RESET") # others reset/hidden

func show_pda() -> void:
	pda.enabled = true
	anim.play("pda_fade")
	for i in range(logs.size()):
		var mlog = logs[i]
		mlog.enabled = false
		mlog.anim.play("RESET")
