class_name Ball
extends RigidBody2D

@export var parameters: BallResource

func _ready() -> void:
	pass
	
func _draw() -> void:
	if !parameters:
		queue_free()
		return
		
	draw_circle(
		Vector2.ZERO,
		parameters.get_radius(),
		parameters.get_color()
	)
