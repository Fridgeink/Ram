extends Node

var rng = RandomNumberGenerator.new()
@onready var hum: AudioStreamPlayer = $Hum

@onready var bump: AudioStreamPlayer = $Bump

func hum_noise():
	hum.play()

func bump_noise():
	var bump_pitch_rng = rng.randf_range(0.9,1.1)
	bump.set_pitch_scale(bump_pitch_rng)
	bump.play()
