extends Node

var active_playlist := "reset"

var file_name: String = ""

var playlist_states := {}

var playlists := {
	"reset": ["Reset"],
	"title": ["MEMORY"],
	"memory": ["VOYAGE", "COSMIC WAVE", "DEEP", "SYSTEM INITIALIZE", "THICK SMOG"],
	"computer": ["OMI"],
}

func _setup_all_playlists():
	playlist_states.clear()
	for key in playlists:
		playlist_states[key] = {
			"songs": [],
			"index": 0,
			"paused_position": 0.0,
			"is_paused": false
		}
		_load_playlist_nodes(key, key.to_pascal_case(), playlists[key], "res://assets/music/%s/" % key)

func _ready():
	_setup_all_playlists()

# Playlist management
func _load_playlist_nodes(key: String, parent_node_name: String, playlist: Array, folder_path: String):
	var parent_node = get_node_or_null(parent_node_name)
	if not parent_node:
		push_error("Parent node not found: " + parent_node_name)
		return

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
	_pause_current_song() # Save current playlist's state before switching
	active_playlist = key
	var state = playlist_states[key]

	if state["songs"].is_empty():
		push_error("Playlist is empty: " + key)
		return

	play_song(state["index"], state["paused_position"] if state["is_paused"] else 0.0)

func _pause_current_song():
	var state = playlist_states[active_playlist]
	if state["songs"].size() > 0:
		var song = state["songs"][state["index"]]
		if song and song.playing:
			state["paused_position"] = song.get_playback_position()
			state["is_paused"] = true
			song.stop()

func play_song(index: int, position: float = 0.0):
	var state = playlist_states[active_playlist]
	for s in state["songs"]:
		if s:
			s.stop()

	state["index"] = index
	var song = state["songs"][index]
	if song and song.stream:
		song.play(position)  # play() takes a from_position argument
		state["is_paused"] = false
		state["paused_position"] = position

func _on_song_finished():
	var state = playlist_states[active_playlist]

	state["index"] = (state["index"] + 1) % state["songs"].size()
	play_song(state["index"])

func toggle_pause():
	var state = playlist_states[active_playlist]
	var song = state["songs"][state["index"]]

	if not song:
		return

	if state["is_paused"]:
		play_song(state["index"], state["paused_position"])
	else:
		state["paused_position"] = song.get_playback_position()
		song.playing = false
		state["is_paused"] = true
