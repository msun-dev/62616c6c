class_name BallResource
extends Resource

@export var color: Color
var bounciness: float = 0.8
var radius: float = 5.

func get_color() -> Color:
	return color

func get_bounciness() -> float:
	return bounciness

func get_radius() -> float:
	return radius
