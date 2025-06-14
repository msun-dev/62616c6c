class_name Pad
extends Resource

@export var sample: Sample
@export var color: Color
@export var pos_a: Vector2
@export var pos_b: Vector2

var center: Vector2
var length: float
var rotation: float

func _init() -> void:
	calculate_parameters()

func calculate_parameters() -> void:
	if !pos_a && !pos_b:
		printerr("Tried to calculate parameters with empty coordinates")
		return
	center = (pos_a + pos_b) / 2
	length = (pos_a - pos_b).length()
	rotation = pos_a.angle_to_point(center)
