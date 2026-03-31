extends Area2D
class_name InteractableArea

@export var enabled: bool = true
@export var type: String
@export var next_scene: String

@onready var sprite: TextureRect = $PressedSprite
@onready var area_name = str(self.name.to_lower())
@onready var parent := get_node("../..")

const DEFAULT_SPRITE = "res://assets/sprites/interact_sprites/default.png"
var hovered: bool = false

func _ready() -> void:
	sprite.visible = false
	update_icon()

func _process(_delta):
	if Engine.is_editor_hint():
		update_icon()

func _input(event: InputEvent) -> void:
	if type == "bump":
		if event.is_action_pressed("click") and hovered:
			if not enabled:
				SfxController.bump_noise()
			else:
				SfxController.click_noise()
				sprite.visible = true
		elif event.is_action_released("click"):
			sprite.visible = false
	if type == "scene":
		if event.is_action_pressed("click") and hovered:
			CursorManager.hover = false
			if parent.name == "Tutorial":
				parent.anim.play("done")
			elif parent.name == "Computer":
				sprite.visible = true
				enabled = false
				parent.button_press()
			else:
				parent.next_scene = next_scene
				parent.transition.off()

func _on_mouse_entered() -> void:
	if enabled:
		CursorManager.hover = true
		hovered = true
		if type == "scene":
			SfxController.clang_noise()

func _on_mouse_exited() -> void:
	if enabled:
		CursorManager.hover = false
		hovered = false

func update_icon():
	if sprite == null:
		return
	var path = "res://assets/sprites/interact_sprites/%s.png" % area_name
	if ResourceLoader.exists(path):
		sprite.texture = load(path)
	else:
		sprite.texture = load(DEFAULT_SPRITE)
