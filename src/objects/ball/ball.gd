class_name Ball
extends RigidBody2D

@onready var collision: CollisionShape2D = $Collision
@onready var timer: Timer = $Timer
@onready var death_timer: Timer = $DeathTimer
@onready var trail_particle: GPUParticles2D = $Trail

@export var collision_particle: PackedScene

var parameters: BallResource
var contact_pos := Vector2.ZERO

func _ready() -> void:
	if !parameters:
		#queue_free()
		return
	await ready
	collision.get_shape().set_radius(parameters.get_radius())
	get_physics_material_override().set_bounce(parameters.get_bounciness())
	var trail_modulate: Color = parameters.get_color()
	trail_modulate.a = 0.5
	trail_particle.set_modulate(trail_modulate)

func _integrate_forces(state) -> void:
	var contact_point = state.get_contact_collider_position(0)
	if contact_point:
		contact_pos = contact_point
	else:
		contact_pos = Vector2.ZERO

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

func _create_collision_particle() -> void:
	var sc = preload("res://src/objects/ball/ball_collision_particle.tscn")
	var particle = sc.instantiate()
	var c: Color = parameters.get_color()
	# TODO: move magic vars
	c.a = 0.45
	c.lightened(0.2)
	particle.set_modulate(c)
	if contact_pos:
		particle.set_global_position(contact_pos)
	
	get_tree().get_root().add_child(particle)
	# My finest creation. Also you can use semicolons in lambdas if you need to! Neat! 
	particle.finished.connect((func(b): b.queue_free()).bind(particle))
	particle.restart()

func _on_body_entered(body) -> void:
	_create_collision_particle()
	if parameters.get_sample_cd() == 0:
		SamplePlayer.play_sample(parameters.get_sample())
		return
	if !timer.is_stopped():
		return
	SamplePlayer.play_sample(parameters.get_sample())
	timer.start(parameters.get_sample_cd())

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func die() -> void:
	queue_free()
