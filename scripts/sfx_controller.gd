extends Node

var rng = RandomNumberGenerator.new()
@onready var hum: AudioStreamPlayer = $Hum

@onready var bump: AudioStreamPlayer = $Bump
@onready var click: AudioStreamPlayer = $Click

func hum_noise():
	hum.play()

func bump_noise():
	var bump_pitch_rng = rng.randf_range(0.9,1.1)
	bump.set_pitch_scale(bump_pitch_rng)
	bump.play()

func click_noise():
	var click_pitch_rng = rng.randf_range(0.9,1.1)
	click.set_pitch_scale(click_pitch_rng)
	click.play()
