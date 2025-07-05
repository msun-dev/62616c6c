class_name EmitterResource
extends Resource

@export var sample_params: SampleResource
@export var color: Color # TODO: Remove ball_params and add color to emitter 
@export var position: Vector2
@export var cooldown: float
@export var disabled: bool

func set_position(p: Vector2) -> void:
	position = p

func set_cooldown(c: float) -> void:
	cooldown = c

func get_sample_params() -> SampleResource:
	return sample_params

func get_cooldown() -> float:
	return cooldown

func get_color() -> Color:
	return color

func is_disabled() -> bool:
	return disabled
