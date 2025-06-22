class_name Emitter
extends Marker2D

@onready var timer: Timer = %Timer

const ball_object = "res://src/objects/ball/ball.tscn"

@export var parameters: EmitterResource
@export var ball_pool: Pool

func _init(p: Pool = null) -> void:
	if p:
		ball_pool = p # TODO: Will break parameters export, probably
	else:
		pass

func _process(delta) -> void:
	if parameters.is_disabled() && !timer:
		return
	if timer.is_stopped():
		emit_ball()
		timer.start(parameters.get_cooldown())

func update_position(p: Vector2) -> void:
	parameters.set_position(p)
	set_position(p)

func emit_ball() -> void:
	var ball: Ball = preload(ball_object).instantiate()
	ball.parameters = parameters.get_ball_params()
	ball.parameters.set_sample(parameters.get_sample_params())
	ball.parameters.get_sample().initiate_sample() # TODO: Remove
	ball.parameters.set_color(Color(randf(), randf(), randf()))
	ball.set_global_position(get_global_position()) # yeah...
	ball_pool.add_child(ball)
	pass
