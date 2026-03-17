@tool
class_name ShakeEffect extends RichTextEffect

var rng = RandomNumberGenerator.new()

func _process_custom_fx(char_fx: CharFXTransform):
	if !char_fx.env.has("time"):
		return false

	var time = char_fx.env["time"]
	var amplitude = 2.0  # shake intensity
	var speed = 20.0     # shake speed

	char_fx.offset.x += sin(time * speed + char_fx.relative_index) * amplitude
	char_fx.offset.y += cos(time * speed + char_fx.relative_index) * amplitude

	return true
