extends CanvasLayer

@onready var parent = get_node("..")
@onready var material = $ColorRect.material
@onready var color_rect: ColorRect = $ColorRect

func _ready():
	on()

func on():
	material.set_shader_parameter("reverse", true)
	material.set_shader_parameter("progress", 1.0)
	
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 0.5)
	await tween.finished
	hide()


func off():
	show()
	material.set_shader_parameter("reverse", false)
	material.set_shader_parameter("progress", 0.0)

	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 0.5)
	await tween.finished
	await get_tree().process_frame
	parent.next()
