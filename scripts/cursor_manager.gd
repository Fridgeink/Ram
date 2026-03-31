extends CanvasLayer

@onready var cursor: Sprite2D = $Cursor
@onready var cursor_hover: Sprite2D = $CursorHover
var hover: bool = false

func _process(_delta: float) -> void:
	if hover:
		cursor.hide()
		cursor_hover.show()
	else:
		cursor.show()
		cursor_hover.hide()
