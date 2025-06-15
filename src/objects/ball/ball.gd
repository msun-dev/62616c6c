class_name Ball
extends RigidBody2D

@export var parameters: BallResource

@onready var collision: CollisionShape2D = $Collision

func _ready() -> void:
	if !parameters:
		queue_free()
		return
	await ready
	collision.get_shape().set_radius(parameters.get_radius())

func _draw() -> void:
	if !parameters:
		queue_free()
		return
		
	draw_circle(
		Vector2.ZERO,
		parameters.get_radius(),
		parameters.get_color()
	)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
