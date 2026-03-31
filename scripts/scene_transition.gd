extends CanvasLayer

@onready var parent = get_node("..")
@onready var material = $ColorRect.material
@onready var color_rect: ColorRect = $ColorRect
@onready var next

func on():
	material.set_shader_parameter("reverse", true)
	material.set_shader_parameter("progress", 1.0)
	
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 0.0, 0.5)
	await tween.finished
	hide()
	if parent.name.to_lower() == "splash":
		parent.anim.play("intro")


func off():
	show()
	material.set_shader_parameter("reverse", false)
	material.set_shader_parameter("progress", 0.0)

	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, 0.5)
	await tween.finished
	await get_tree().process_frame
	change_to_next()

func change_to_next():
	#print("res://scenes/" + str(parent.next_scene) + ".tscn")
	CursorManager.hover = false
	Global.loading = "res://scenes/" + parent.next_scene + ".tscn"
	var loading_screen = load("res://scenes/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)
