class_name Ball
extends RigidBody2D

@onready var collision: CollisionShape2D = $Collision

var parameters: BallResource

func _ready() -> void:
	if !parameters:
		#queue_free()
		return
	await ready
	collision.get_shape().set_radius(parameters.get_radius())
	get_physics_material_override().set_bounce(parameters.get_bounciness())

func _draw() -> void:
	if !parameters:
		queue_free()
		return
		
	draw_circle(
		Vector2.ZERO,
		parameters.get_radius(),
		parameters.get_color()
	)

func _on_body_entered(body):
	# TODO: Add `if pad` statement
	SamplePlayer.play_sample_at(parameters.get_sample(), get_global_position())
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
