class_name BallResource
extends Resource

var color: Color
var sample: SampleResource
var bounciness: float = 0.8
var radius: float = 5.

func set_color(c: Color) -> void:
	pass

func set_sample(s: SampleResource) -> void:
	sample = s

func get_color() -> Color:
	return color

func get_bounciness() -> float:
	return bounciness

func get_radius() -> float:
	return radius
