@tool
extends RichTextEffect
class_name WaveEffect

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if not char_fx.env.has("time"):
		return false

	var time: float = char_fx.env["time"]

	# Default values
	var amplitude: float = 12.0
	var speed: float = 8.0

	# Parse and convert string parameters from Dialogic
	if char_fx.env.has("amplitude"):
		amplitude = str(char_fx.env["amplitude"]).to_float()
	if char_fx.env.has("speed"):
		speed = str(char_fx.env["speed"]).to_float()

	char_fx.offset.y += sin(time * speed + char_fx.relative_index * 0.5) * amplitude

	return true
