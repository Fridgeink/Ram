extends CanvasLayer

# Sprite for the custom cursor
@onready var cursor: Sprite2D = $Cursor

# Variables for the timer
var total_time: float = 2 # Default time in seconds
@onready var timer_label: Label = $TimerVisuals/TimerLabel # Reference to the Label node
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
	# Convert seconds to minutes:seconds format
	var minutes = int(total_time) / 60
	var seconds = int(total_time) % 60
	timer_label.text = "%01d:%02d" % [minutes, seconds]

func on_timer_finished():
	# Handle what happens when the timer finishes
	timer_label.text = "0:00"
