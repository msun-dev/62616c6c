class_name BallResource
extends Resource

@export var color: Color
var radius: float = 5. # TODO: Make @export if needed

func get_color() -> Color:
	return color

func get_radius() -> float:
	return radius
