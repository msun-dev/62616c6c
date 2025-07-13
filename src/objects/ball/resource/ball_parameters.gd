'''
Actually, there is no need to have a resource for balls since I don't need to save them.
Since I've already implemented it there is no turning back.
'''
class_name BallResource
extends Resource

@export var color: Color
@export var sample: SampleResource
@export var bounciness: float = 0.8
@export var radius: float = 5.
var minimal_speed: float = .0
var sample_cd: float = .0

func set_color(c: Color) -> void:
	color = c

func set_sample(s: SampleResource) -> void:
	sample = s

func set_minimal_speed(s: float) -> void:
	minimal_speed = s

func get_color() -> Color:
	return color

func get_sample() -> SampleResource:
	return sample

func get_bounciness() -> float:
	return bounciness

func get_radius() -> float:
	return radius

func get_sample_cd() -> float:
	return sample_cd

func get_minimal_speed() -> float:
	return minimal_speed
