@tool
extends RichTextEffect
class_name GlitchEffect

var bbcode = "glitch"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if randf() < 0.2:
		char_fx.offset.x += randf_range(-3.0, 3.0)
	return true
