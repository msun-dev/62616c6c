'''
I don't really like how positions in godot are handled.
For this project in this pad object, for example, I have to 
create a Pad with pos_a that starts at mouse position.....

Wait, maybe I'm wrong...

- [x] TODO: Update this comment

There are to_global and to_local methods exist. Check them out!

Also pad is implemented wrong since %Shape is in global coords and %Pad sits at (0, 0)
'''
class_name Pad
extends Node2D

@onready var collision: StaticBody2D = $Collision
@onready var shape: CollisionShape2D = %Shape
@onready var hitbox: Area2D = $HitBox
@onready var mouse_shape: CollisionShape2D = %MouseShape
@onready var particle_death: GPUParticles2D = $ParticleDeath

@export var parameters: PadResource

const mouse_hitbox_size: float = 5

var active := false
var dead := false

func _ready() -> void:
	if !parameters: #TODO: Remove
		queue_free()

func _process(delta) -> void:
	if !active:
		queue_redraw() # NB: Remove if pools are canvaslayers

func _draw() -> void:
	if !parameters || dead:
		return

	var a: Vector2 = parameters.get_pos(0)
	var b: Vector2 = parameters.get_pos(1)
	if a == Vector2.ZERO || b == Vector2.ZERO:
		return

	if active:
		draw_line(a, b, parameters.get_color(), parameters.get_width())
	else:
		draw_dashed_line(a, b, parameters.get_color(), parameters.get_width(), 3.)

func _update_collision() -> void:
	#shape.set_global_position(parameters.get_center_pos())
	#shape.set_rotation(parameters.get_rotation())
	shape.set_disabled(false)
	shape.shape.set_a(parameters.get_pos(0))
	shape.shape.set_b(parameters.get_pos(1))
	mouse_shape.shape.set_size(Vector2(parameters.get_length(), mouse_hitbox_size))
	mouse_shape.set_position(parameters.get_center_pos())
	mouse_shape.set_rotation(parameters.get_rotation())
	particle_death.set_amount(int(parameters.get_length() / 5))
	particle_death.get_process_material().set_emission_box_extents(
		Vector3(parameters.get_length() / 2, 1, 1)
	)
	particle_death.set_rotation(parameters.get_rotation())
	particle_death.set_global_position(parameters.get_center_pos())
	particle_death.set_modulate(parameters.get_color())

func on_ball_collision(b: Ball) -> void:
	pass

func update_position(i: int, p: Vector2) -> void:
	parameters.set_pos(i, p)
	
func set_active() -> void:
	active = true
	_update_collision()

func destroy() -> void:
	if dead:
		return
	
	dead = true
	queue_redraw()
	shape.set_disabled(true)
	particle_death.restart()
	#particle_death.set_emitting(true)
	await particle_death.finished
	queue_free()
