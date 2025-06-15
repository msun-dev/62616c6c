class_name Emitter
extends Marker2D

@export var parameters: EmitterResource

var ball_pool: Pool

func _init(p: Pool) -> void:
	ball_pool = p # TODO: Will break parameters export, probably

func _process(delta) -> void:
	if parameters.is_disabled():
		return
	await get_tree().create_timer(parameters.get_cooldown()).timeout
	emit_ball()

func emit_ball() -> void:
	
	pass
