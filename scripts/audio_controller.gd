extends Node

var rng = RandomNumberGenerator.new()

var title_songs := [
	"Memory",
]

var active_playlist := "title"

var previous_playlist := ""

var file_name: String = ""

var playlist_toggle := 0

var playing_theme: bool = true

var playlist_states := {}

@warning_ignore("unused_signal")
signal song_changed(new_song_name: String)

func _setup_all_playlists():
	playlist_states.clear()

	var script_props = get_script().get_script_property_list()

	for prop in script_props:
		var prop_name: String = prop.name

		# Only process variables ending in "_songs"
		if prop_name.ends_with("_songs"):
			var playlist_array: Array = get(prop_name)
			var key := prop_name.replace("_songs", "") # e.g. "title_songs" -> "title"

			# Create playlist state automatically
			playlist_states[key] = {
				"songs": [],
				"index": 0,
				"paused_position": 0.0,
				"is_paused": false
			}

			# Auto-generate parent node name (Title, Menu, Map2, etc.)
			var parent_node_name := key.capitalize()

			# Special handling for names with underscores like "aether_intro"
			if key.contains("_"):
				var parts = key.split("_")
				parent_node_name = ""
				for part in parts:
					parent_node_name += part.capitalize()

			# Auto folder path
			var folder_path := "res://assets/music/%s/" % key

			_load_playlist_nodes(key, parent_node_name, playlist_array, folder_path)

func _ready():
	_setup_all_playlists()

func _process(_float) -> void:
	if playing_theme and Dialogic.VAR.box == false:
		resume_previous_playlist()

#func _input(event):
	##if event.is_action_pressed("pause_song"):
		##toggle_pause()
	#if event.is_action_pressed("mute"):
		#if Global.music_mute:
			#Global.music_mute = false
		#else:
			#Global.music_mute = true
		#mute_music()
	#elif event.is_action_pressed("skip_song"):
		#skip_song()

# -------------------------
# Playlist management
# -------------------------
func _load_playlist_nodes(key: String, parent_node_name: String, playlist: Array, folder_path: String):
	var parent_node = get_node_or_null(parent_node_name)
	if not parent_node:
		push_error("Parent node not found: " + parent_node_name)
		return

	playlist_states[key]["songs"].clear()

	for song_name in playlist:
		var song_node = parent_node.get_node_or_null(song_name)
		if song_node:
			playlist_states[key]["songs"].append(song_node)
			var file_path = folder_path + song_node.name + ".mp3"
			if ResourceLoader.exists(file_path):
				song_node.stream = load(file_path)
			#else:
				#push_error("Music file not found: " + file_path)
			song_node.finished.connect(_on_song_finished)
		#else:
			#push_error("Song node missing under " + parent_node_name + ": " + song_name)

func play_playlist(key: String):
	playing_theme = false
	_pause_current_song() # Save current playlist's state before switching
	active_playlist = key
	var state = playlist_states[key]

	if state["songs"].is_empty():
		push_error("Playlist is empty: " + key)
		return

	if state["is_paused"]:
		_resume_song(state["index"], state["paused_position"])
	else:
		# Force a "skip" to start fresh and update title
		play_song(state["index"])

func _pause_current_song():
	var state = playlist_states[active_playlist]
	if state["songs"].size() > 0:
		var song = state["songs"][state["index"]]
		if song and song.playing:
			state["paused_position"] = song.get_playback_position()
			state["is_paused"] = true
			song.stop()

# -------------------------
# Song playback
# -------------------------
func skip_song():
	if playing_theme == false:
		var state = playlist_states[active_playlist]
		if state["songs"].size() == 0:
			return

		var song = state["songs"][state["index"]]
		if song:
			song.stop()

		state["index"] = (state["index"] + 1) % state["songs"].size()
		state["paused_position"] = 0.0
		state["is_paused"] = false
		play_song(state["index"])

func play_song(index: int):
	var state = playlist_states[active_playlist]
	for s in state["songs"]:
		if s:
			s.stop()

	state["index"] = index
	var song = state["songs"][state["index"]]
	if song and song.stream:
		song.play()
		state["is_paused"] = false
		state["paused_position"] = 0.0

		file_name = song.stream.resource_path.get_file().get_basename()
		emit_signal("song_changed", file_name)

func _resume_song(index: int, position: float):
	var state = playlist_states[active_playlist]
	for s in state["songs"]:
		if s:
			s.stop()

	state["index"] = index
	var song = state["songs"][state["index"]]
	if song and song.stream:
		song.play()
		song.seek(position)
		state["is_paused"] = false

		file_name = song.stream.resource_path.get_file().get_basename()
		emit_signal("song_changed", file_name) # Ensure UI updates

func _on_song_finished():
	var state = playlist_states[active_playlist]
	var song = state["songs"][state["index"]]

	if song and song.name == "Intro":
		return

	state["index"] = (state["index"] + 1) % state["songs"].size()
	play_song(state["index"])


func toggle_pause():
	var state = playlist_states[active_playlist]
	var song = state["songs"][state["index"]]

	if not song:
		return

	if state["is_paused"]:
		_resume_song(state["index"], state["paused_position"])
	else:
		state["paused_position"] = song.get_playback_position()
		song.playing = false
		state["is_paused"] = true

func play_specific_song(song_name: String):
	playing_theme = true
	previous_playlist = active_playlist  # Save current playlist
	#print(previous_playlist)
	_pause_current_song() # Save current playlist's state before switching
	# Search through all playlists
	for key in playlist_states.keys():
		var state = playlist_states[key]
		for i in range(state["songs"].size()):
			var song = state["songs"][i]
			if song and song.name == song_name:
				active_playlist = key
				# Stop any currently playing song
				for s in state["songs"]:
					if s:
						s.stop()

				state["index"] = i
				state["paused_position"] = 0.0
				state["is_paused"] = false

				song.play()
				song.stream.set_loop(true)  # Enable looping for this song

				file_name = song.stream.resource_path.get_file().get_basename()
				emit_signal("song_changed", file_name)
				return

	push_error("Song not found in any playlist: " + song_name)

func resume_previous_playlist():
	if previous_playlist != "":
		play_playlist(previous_playlist)
		previous_playlist = active_playlist
