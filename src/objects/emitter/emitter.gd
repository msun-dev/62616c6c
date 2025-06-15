class_name Emitter
extends Marker2D

@onready var timer: Timer = %Timer

const ball_object = "res://src/objects/ball/ball.tscn"

@export var parameters: EmitterResource

var ball_pool: Pool

func _init(p: Pool = null) -> void:
	if p:
		ball_pool = p # TODO: Will break parameters export, probably
	else:
		pass

func _process(delta) -> void:
	if parameters.is_disabled() && !timer:
		return
	#await get_tree().create_timer(parameters.get_cooldown()).timeout
	if timer.is_stopped():
		emit_ball()
		timer.start(parameters.get_cooldown())

func update_position(p: Vector2) -> void:
	parameters.set_position(p)
	set_position(p)

func emit_ball() -> void:
	var ball: Ball = preload(ball_object).instantiate()
	ball.parameters = parameters.get_ball_params()
	add_child(ball)
	pass
