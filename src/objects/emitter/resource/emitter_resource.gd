class_name EmitterResource
extends Resource

@export var ball_params: BallResource
@export var sample_params: SampleResource
@export var position: Vector2
@export var cooldown: float
@export var disabled: bool

func set_position(p: Vector2) -> void:
	position = p

func set_ball_params(bp: BallResource) -> void:
	ball_params = bp

func set_cooldown(c: float) -> void:
	cooldown = c

func get_ball_params() -> BallResource:
	return ball_params

func get_sample_params() -> SampleResource:
	return sample_params

func get_cooldown() -> float:
	return cooldown

func is_disabled() -> bool:
	return disabled
