class_name Ball
extends RigidBody2D

@onready var collision: CollisionShape2D = $Collision
@onready var timer: Timer = $Timer
@onready var death_timer: Timer = $DeathTimer

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

func _physics_process(delta) -> void:
	if get_linear_velocity() == Vector2.ZERO:
		die()

func die() -> void:
	queue_free()

func _on_body_entered(body) -> void:
	if parameters.get_sample_cd() == 0:
		SamplePlayer.play_sample(parameters.get_sample())
		return
	if !timer.is_stopped():
		return
	SamplePlayer.play_sample(parameters.get_sample())
	#SamplePlayer.play_sample_at(parameters.get_sample(), get_global_position())
	timer.start(parameters.get_sample_cd())

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
