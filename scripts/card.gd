extends Control

signal flipped(card)

@export var scale_factor: float = 1.0
@onready var scaler: Node2D = $Scaler
@onready var anim: AnimationPlayer = $AnimationPlayer

var hovered: bool = false
var enabled: bool = true

var is_face_up := false
var is_matched := false

func _ready() -> void:
	scaler.scale = Vector2(scale_factor, scale_factor)
	anim.play("RESET")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hovered and enabled:
		if is_face_up or is_matched:
			return

		is_face_up = true
		anim.play("turn")

		emit_signal("flipped", self)

func turn_around() -> void:
	is_face_up = false
	anim.play("turn_back")

func set_matched() -> void:
	CursorManager.hover = false
	is_matched = true
	enabled = false

func _on_mouse_entered() -> void:
	CursorManager.hover = true
	hovered = true

func _on_mouse_exited() -> void:
	CursorManager.hover = false
	hovered = false
