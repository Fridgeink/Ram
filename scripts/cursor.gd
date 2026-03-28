extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	var desired_scale: Vector2 = Vector2(2.5, 2.5) if Input.is_action_pressed("click") else Vector2(3.0,3.0)
	scale = lerp(scale, desired_scale, 16 * delta)
