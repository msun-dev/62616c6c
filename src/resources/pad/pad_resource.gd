class_name PadResource
extends Resource

@export var sample: SampleResource
@export var color: Color
@export var pos_a: Vector2
@export var pos_b: Vector2

var center: Vector2
var length: float
var rotation: float

func _init() -> void:
	_calculate_parameters()

func set_pos(i: int, p: Vector2) -> void:
	match i:
		0:
			pos_a = p
		1:
			pos_b = p
	_calculate_parameters()

func _calculate_parameters() -> void:
	if !pos_a && !pos_b:
		printerr("Tried to calculate parameters with empty coordinates")
		return
	center = (pos_a + pos_b) / 2
	length = (pos_a - pos_b).length()
	rotation = pos_a.angle_to_point(center)
