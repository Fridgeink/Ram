extends CanvasLayer

@export var total_time: float = 120.0  # e.g. 2 minutes
@onready var timer_label: Label = $TimerVisuals/TimerLabel

var enabled: bool = true


func _ready():
	update_timer_label()


func start_timing():
	enabled = true


func _process(delta: float) -> void:
	if not enabled:
		return

	total_time -= delta

	if total_time <= 0.0:
		total_time = 0.0
		enabled = false
		on_timer_finished()

	update_timer_label()


func update_timer_label():
	var minutes: int = int(total_time / 60.0)
	var seconds: int = int(fmod(total_time, 60.0))

	timer_label.text = "%01d:%02d" % [minutes, seconds]

func on_timer_finished():
	timer_label.text = "0:00"
