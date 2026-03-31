extends Control

@onready var parent = get_node("..")

# Variables for the timer
@export var total_time: float = 12 # Default time in seconds
@onready var timer_label: Label = $TimerLabel # Reference to the Label node
@onready var timer_node: Timer = $Timer # Reference to the Timer node

var enabled: bool = true

func _ready():
	update_timer_label()

func start_timing():
	enabled = true
	timer_node.start()

func _on_timer_timeout():
	# Decrease the total time
	if enabled:
		total_time -= 1.0

	# Update the Label text
	update_timer_label()
	#if total_time == 5:
		#AudioController.in_game_timer_sfx.play()
	# Stop the timer when time runs out
	if total_time <= 0:
		timer_node.stop()
		on_timer_finished()

func update_timer_label():
	var minutes: int = int(total_time / 60.0)
	var seconds: int = int(fmod(total_time, 60.0))
	timer_label.text = "%01d:%02d" % [minutes, seconds]

func on_timer_finished():
	Global.button_pressed = false
	# Handle what happens when the timer finishes
	timer_label.text = "0:00"
	AudioController.play_playlist("reset")
	parent.transition.off()
