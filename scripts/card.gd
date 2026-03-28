extends Control

@export var scale_factor: float = 1.0
@onready var scaler: Node2D = $Scaler
@onready var anim: AnimationPlayer = $AnimationPlayer
var hovered: bool = false
var flipped: bool = true

func _ready() -> void:
	scaler.scale = Vector2(scale_factor, scale_factor)
	anim.play("RESET")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hovered:
		anim.play("turn")

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false
