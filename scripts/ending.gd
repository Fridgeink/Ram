extends Control

var rng = RandomNumberGenerator.new()

@onready var label: Label = $Label
@onready var transition: CanvasLayer = $SceneTransition
@onready var timer: Timer = $Timer
@onready var next_scene: String = "splash"
@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.on()
	anim.play("RESET")
	choose_ending()
	if Global.button_pressed:
		label.text = "You pressed the button"
	else:
		label.text = "You didn't press the button."
	
func choose_ending() -> void:
	var ending: int
	ending = rng.randi_range(1,2)
	if ending == 1:
		timer.start()
	else:
		await get_tree().create_timer(4).timeout
		anim.play("bang")


func _input(event):
	if event.is_action_pressed("skip"):
		timer.stop()
		transition.off()

func _on_timer_timeout() -> void:
	transition.off()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "bang":
		transition.off()
