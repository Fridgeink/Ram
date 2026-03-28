extends Control

@onready var card_grid: Control = $CardGrid

var card: PackedScene = preload("res://scenes/card.tscn")

var textures: Array = []
var cards: Array = []

@export var scale_factor: float = 3
@export var rows: int = 4
@export var cols: int = 4

var card_size: Vector2
var offset: Vector2


func _ready() -> void:
	if AudioController.active_playlist != "level1":
		AudioController.play_playlist("level1")
	
	InGameUi.start_timing()
	# Load textures dynamically
	load_card_textures("res://assets/sprites/")

	card_size = Vector2(24, 28) * scale_factor
	offset = card_size / 2

	var total_cards := rows * cols
	var needed_pairs := total_cards / 2

	var temp_textures = textures.duplicate()
	temp_textures.shuffle()

	# Distribute pairs evenly across textures
	var pairs_per_texture = needed_pairs / temp_textures.size()
	var remainder = needed_pairs % temp_textures.size()

	for i in range(temp_textures.size()):
		var t = temp_textures[i]
		var pair_count = pairs_per_texture

		if i < remainder:
			pair_count += 1

		for p in range(pair_count):
			for j in range(2):
				var c = card.instantiate()
				c.get_node("Scaler/Front").texture = t
				cards.append(c)

	# Handle odd grid (1 extra card)
	if total_cards % 2 != 0:
		var t = temp_textures[0]
		var extra = card.instantiate()
		extra.get_node("Scaler/Front").texture = t
		cards.append(extra)

	# Shuffle final deck
	cards.shuffle()

	# Place cards
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


# Loads only "card_*.png"
func load_card_textures(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Failed to open texture directory: " + path)
		return

	var file_names: Array = []

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if !dir.current_is_dir() \
		and file_name.begins_with("card_") \
		and file_name.ends_with(".png"):
			file_names.append(file_name)

		file_name = dir.get_next()

	dir.list_dir_end()

	# Sort alphabetically
	#file_names.sort()

	# Load textures in sorted order
	for text_name in file_names:
		var file_path = path + text_name
		var tex := load(file_path)

		if tex:
			textures.append(tex)
		else:
			push_error("Failed to load texture: " + file_path)
