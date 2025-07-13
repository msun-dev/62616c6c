class_name EmitterResource
extends Resource

@export var sample_params: SampleResource
@export var color: Color
@export var position: Vector2
@export var cooldown: float
@export var disabled: bool

func set_sample(s: SampleResource) -> void:
	sample_params = s

func set_color(c: Color) -> void:
	color = c

func set_position(p: Vector2) -> void:
	position = p

func set_cooldown(c: float) -> void:
	cooldown = c

func set_disabled(d: bool) -> void:
	disabled = d

func get_sample_params() -> SampleResource:
	return sample_params

func get_color() -> Color:
	return color

func get_pos() -> Vector2:
	return position

func get_cooldown() -> float:
	return cooldown

func is_disabled() -> bool:
	return disabled
