class_name Ball
extends RigidBody2D

@onready var collision: CollisionShape2D = $Collision
@onready var timer: Timer = $Timer
@onready var death_timer: Timer = $DeathTimer
@onready var trail_particle: GPUParticles2D = $Trail
@onready var particle_death: GPUParticles2D = $ParticleDeath
@onready var collision_particle: PackedScene = preload("res://src/objects/ball/ball_collision_particle.tscn")

const ParticleAlphaAmount: float = 0.3
const ParticleLightenAmount: float = 0.2
const ScreenExitToDespawnTime: float = 0.5

var parameters: BallResource
var contact_pos := Vector2.ZERO
var dead := false

func _ready() -> void:
	if !parameters:
		#queue_free()
		return
	collision.get_shape().set_radius(parameters.get_radius())
	get_physics_material_override().set_bounce(parameters.get_bounciness())
	var color: Color = parameters.get_color()
	particle_death.set_modulate(color)
	color.a = 0.5
	trail_particle.set_modulate(color)

func _integrate_forces(state) -> void:
	# First created ball doesnt emit any contact points for some reasons.
	#TODO: fix!
	var contact_point = state.get_contact_collider_position(0)
	if contact_point:
		contact_pos = contact_point
	else:
		contact_pos = Vector2.ZERO

func _draw() -> void:
	if !parameters:
		queue_free()
		return
	if dead:
		return
	draw_circle(
		Vector2.ZERO,
		parameters.get_radius(),
		parameters.get_color()
	)

func _physics_process(delta) -> void:
	if get_linear_velocity() == Vector2.ZERO:
		destroy()

func _create_collision_particle() -> void:
	var sc = load("res://src/objects/ball/ball_collision_particle.tscn")
	var particle = sc.instantiate()
	var c: Color = parameters.get_color()
	c.a = ParticleAlphaAmount
	c.lightened(ParticleLightenAmount)
	particle.set_modulate(c)
	if contact_pos:
		particle.set_global_position(contact_pos)
	
	# Super unsafe line of code
	get_tree().get_root().get_node("World/Pools/ParticlePool").add_child(particle)
	
	# My finest creation. Also you can use semicolons in lambdas if you need to! Neat! 
	particle.finished.connect((func(b): b.queue_free()).bind(particle))
	particle.restart()

func _on_body_entered(body) -> void:
	_create_collision_particle()
	body.get_parent().on_ball_collision(self) # HACK: unsafe as heck 
	if parameters.get_sample_cd() == 0:
		SamplePlayer.play_sample(parameters.get_sample())
		return
	if !timer.is_stopped():
		return
	SamplePlayer.play_sample(parameters.get_sample())
	timer.start(parameters.get_sample_cd())

func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy(true)
	await get_tree().create_timer(ScreenExitToDespawnTime).timeout
	queue_free()

func double_speed() -> void:
	apply_impulse(get_linear_velocity() / 2)

func halve_speed() -> void:
	apply_impulse(-(get_linear_velocity()/2))

func destroy(disable_death_particle: bool = false) -> void:
	if dead:
		return
	
	dead = true
	queue_redraw()
	set_freeze_enabled(true)
	collision.set_disabled(true)
	trail_particle.set_emitting(false)
	if !disable_death_particle:
		particle_death.restart()
		await particle_death.finished
	queue_free()
