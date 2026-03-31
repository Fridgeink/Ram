extends Node

var rng = RandomNumberGenerator.new()
@onready var hum: AudioStreamPlayer = $Hum
@onready var reveal: AudioStreamPlayer = $Reveal

@onready var bump: AudioStreamPlayer = $Bump
@onready var click: AudioStreamPlayer = $Click
@onready var applause: AudioStreamPlayer = $Applause
@onready var clang: AudioStreamPlayer = $Clang

func hum_noise():
	hum.play()

func reveal_noise():
	var reveal_pitch_rng = rng.randf_range(0.9,1.1)
	reveal.set_pitch_scale(reveal_pitch_rng)
	reveal.play()

func bump_noise():
	var bump_pitch_rng = rng.randf_range(0.9,1.1)
	bump.set_pitch_scale(bump_pitch_rng)
	bump.play()

func click_noise():
	var click_pitch_rng = rng.randf_range(0.9,1.1)
	click.set_pitch_scale(click_pitch_rng)
	click.play()

func applause_noise():
	var applause_pitch_rng = rng.randf_range(0.9,1.1)
	applause.set_pitch_scale(applause_pitch_rng)
	applause.play()

func clang_noise():
	var clang_pitch_rng = rng.randf_range(0.9,1.1)
	clang.set_pitch_scale(clang_pitch_rng)
	clang.play()
