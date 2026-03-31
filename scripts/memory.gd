extends Control

var rng = RandomNumberGenerator.new()

@onready var transition: CanvasLayer = $SceneTransition
@onready var next_scene: String = "main_menu"
@onready var in_game_ui: CanvasLayer = $InGameUi
@onready var card_grid: Control = $CardGrid

var card: PackedScene = preload("res://scenes/card.tscn")
var textures: Array = [
	preload("res://assets/sprites/card_0_cas.png"),
	preload("res://assets/sprites/card_0_cd.png"),
	preload("res://assets/sprites/card_0_club.png"),
	preload("res://assets/sprites/card_0_cog.png"),
	preload("res://assets/sprites/card_0_diam.png"),
	preload("res://assets/sprites/card_0_disk.png"),
	preload("res://assets/sprites/card_0_hi.png"),
	preload("res://assets/sprites/card_0_pad.png"),
	preload("res://assets/sprites/card_0_room.png"),
	preload("res://assets/sprites/card_0_spad.png"),
	preload("res://assets/sprites/card_0_thr.png"),
	preload("res://assets/sprites/card_0_usb.png"),
	preload("res://assets/sprites/card_0_zap.png"),
	preload("res://assets/sprites/card_1_blud.png"),
	preload("res://assets/sprites/card_1_egg.png"),
	preload("res://assets/sprites/card_1_horn.png"),
	preload("res://assets/sprites/card_1_moon.png"),
	preload("res://assets/sprites/card_1_orb.png"),
	preload("res://assets/sprites/card_1_que.png"),
	preload("res://assets/sprites/card_1_rib.png"),
	preload("res://assets/sprites/card_1_snow.png"),
	preload("res://assets/sprites/card_1_soul.png"),
	preload("res://assets/sprites/card_1_star.png"),
	preload("res://assets/sprites/card_1_sun.png"),
	preload("res://assets/sprites/card_1_tree.png"),
]
var cards: Array = []
var cards_flipped: Array = []
var is_resolving := false

@export var scale_factor: float = 3
@export var rows: int = 4
@export var cols: int = 4

var card_size: Vector2
var offset: Vector2
var matches: int = 0
var needed_pairs: int = 0
var completed: bool = false


func _ready() -> void:
	transition.on()
	Global.intro_done = true
	if AudioController.active_playlist != "memory":
		AudioController.play_playlist("memory")
	await get_tree().process_frame
	in_game_ui.start_timing()
	build_deck()


func _process(_delta: float) -> void:
	if matches >= needed_pairs and needed_pairs > 0 and not completed:
		completed = true
		in_game_ui.enabled = false
		await get_tree().create_timer(1.0).timeout
		for c in cards:
			c.queue_free()
		cards.clear()
		SfxController.applause_noise()
		Global.logs_complete += 1
		CursorManager.hover = false
		find_level_data()

	if in_game_ui.total_time == 0 and not completed:
		completed = true
		in_game_ui.enabled = false
		await get_tree().create_timer(1.0).timeout
		SfxController.bump_noise()
		Global.logs_complete += 1
		Dialogic.start("fail")

	if Dialogic.VAR.next:
		transition.off()
		return


# SIGNAL HANDLER
func _on_card_flipped(card_node) -> void:
	if is_resolving:
		return
	if card_node in cards_flipped:
		return
	cards_flipped.append(card_node)
	if cards_flipped.size() == 2:
		resolve_turn()


# TURN LOGIC
func resolve_turn() -> void:
	is_resolving = true

	var card1 = cards_flipped[0]
	var card2 = cards_flipped[1]

	var tex1 = card1.get_node("Scaler/Front").texture
	var tex2 = card2.get_node("Scaler/Front").texture

	for c in cards:
		c.enabled = false

	if tex1 == tex2:
		matches += 1

		card1.set_matched()
		card2.set_matched()

		await get_tree().create_timer(0.8).timeout

		card1.queue_free()
		card2.queue_free()

		cards.erase(card1)
		cards.erase(card2)

	else:
		await get_tree().create_timer(1.0).timeout

		card1.turn_around()
		card2.turn_around()

	# ALWAYS re-enable
	for c in cards:
		c.enabled = true

	cards_flipped.clear()
	is_resolving = false

# BUILD DECK
func build_deck() -> void:
	card_size = Vector2(24, 28) * scale_factor
	offset = card_size / 2

	var total_cards: float = float(rows * cols)
	needed_pairs = int(total_cards / 2.0)

	var temp_textures = textures.duplicate()
	temp_textures.shuffle()

	var texture_count: float = float(temp_textures.size())
	var pairs_per_texture: int = int(float(needed_pairs) / texture_count)
	var remainder: int = int(fmod(float(needed_pairs), texture_count))

	for i in range(temp_textures.size()):
		var t = temp_textures[i]
		var pair_count: int = pairs_per_texture
		if i < remainder:
			pair_count += 1
		for _p in range(pair_count):
			for _j in range(2):
				var c = card.instantiate()
				c.get_node("Scaler/Front").texture = t
				c.flipped.connect(_on_card_flipped)
				cards.append(c)

	if int(total_cards) % 2 != 0:
		var t = temp_textures[0]
		var extra = card.instantiate()
		extra.get_node("Scaler/Front").texture = t
		extra.flipped.connect(_on_card_flipped)
		cards.append(extra)

	cards.shuffle()

	var spacing = Vector2(8, 8)
	for row in range(rows):
		for col in range(cols):
			var mem_card = cards[col + row * cols]
			mem_card.scale_factor = scale_factor
			card_grid.add_child(mem_card)
			mem_card.position = Vector2(
				col * (card_size.x + spacing.x),
				row * (card_size.y + spacing.y)
			) + offset


func find_level_data() -> void:
	var corrupt_data: int = rng.randi_range(1, 35)
	if corrupt_data == 1:
		Dialogic.start("fail")
	else:
		choose_data()


func choose_data() -> void:
	var data: int = rng.randi_range(1, 2)
	if data == 1:
		Dialogic.start(str(name).to_lower() + "_png")
	else:
		Dialogic.start(str(name).to_lower() + "_dat")
