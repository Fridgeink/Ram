extends Node

var title: String = "RAM."
var loading : String
var skipping : bool = false

var current_scene : String = ""
var currently_paused: bool = false

var intro_done: bool = false

var logs_complete: int = 3

var button_pressed: bool = false

func _input(event):
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	# Close game instantly for debug
	#if event.is_action_pressed("quit"):
		#get_tree().quit()
	elif event.is_action_pressed("skip") and Dialogic.VAR.box:
			skipping = true

func _process(_delta: float) -> void:
	DisplayServer.window_set_title(title)
	if skipping and Dialogic.VAR.box:
		Dialogic.Inputs.auto_skip.enabled = true
		Dialogic.Inputs.auto_advance.enabled_until_next_event = true
		Dialogic.Inputs.auto_advance.fixed_delay = 0
	elif skipping and not Dialogic.VAR.box:
		Dialogic.Inputs.auto_skip.enabled = false
		Dialogic.Inputs.auto_advance.enabled_until_next_event = false
		skipping = false

func reset_prog() -> void:
	intro_done = false
	logs_complete = 0
	button_pressed = false

# This game uses Godot Engine, available under the following license:
# Copyright (c) 2014-present Godot Engine contributors.
# Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
