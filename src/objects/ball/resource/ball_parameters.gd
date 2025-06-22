class_name BallResource
extends Resource

@export var color: Color
@export var sample: SampleResource
@export var bounciness: float = 0.8
@export var radius: float = 5.

func set_color(c: Color) -> void:
	color = c

func set_sample(s: SampleResource) -> void:
	sample = s

func get_color() -> Color:
	return color

func get_sample() -> SampleResource:
	return sample

func get_bounciness() -> float:
	return bounciness

func get_radius() -> float:
	return radius
