class_name Emitter
extends Marker2D

@onready var timer: Timer = %Timer

@export var parameters: EmitterResource
@export var ball_pool: Pool

const ball_object = "res://src/objects/ball/ball.tscn"

func _init(p: Pool = null) -> void:
	if p:
		ball_pool = p # LTODO: Will break parameters export, probably
	else:
		pass

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, parameters.get_color(), false, 2)
	draw_circle(
		Vector2.ZERO, 
		(parameters.get_cooldown() - timer.get_time_left()) / parameters.get_cooldown() * 5,
		parameters.get_color()
	)

func _process(delta) -> void:
	queue_redraw()
	if parameters.is_disabled() || !timer:
		return
	if timer.is_stopped():
		emit_ball()
		timer.start(parameters.get_cooldown())

func update_position(p: Vector2) -> void:
	parameters.set_position(p)
	set_global_position(p)

func destroy() -> void:
	queue_free()

func emit_ball() -> void:
	var ball: Ball = preload(ball_object).instantiate()
	ball.parameters = BallResource.new()
	ball.parameters.set_sample(parameters.get_sample_params())
	ball.parameters.set_color(parameters.get_color())
	ball.set_global_position(get_global_position()) # yeah...
	ball.set_linear_velocity(Vector2(0, 1))
	ball_pool.add_child(ball)
	pass
