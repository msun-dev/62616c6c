extends Tool

@onready var circle: CircleNode = $CircleNode

@export var emitter_pool: Pool
@export var ball_pool: Pool

const emitter_path: Resource = preload("res://src/objects/emitter/emitter.tscn")
const distance_to_edit: float = 25.
const min_spawn_cd: float = 0.1
const max_spawn_cd: float = 10.
const collision_mask: int = 0x0002

var emitter: Emitter = null
var mouse_rotation: float = 0.
var mouse_pos_start := Vector2.ZERO
var mouse_pos := Vector2.ZERO
var distance_to_mouse: float = 0.
var rotation_to_mouse: float = 0.
var percentage: float = -1.
var current_cd: float = max_spawn_cd

func _ready() -> void:
	super()
	type = 1

func _unhandled_input(event) -> void:
	super(event)

func _process(delta) -> void:
	match state:
		States.MouseUp:
			pass
		States.MouseDown:
			if ResourceManager.are_both_selected():
				mouse_pos = MouseObserver.get_mouse_pos()
				distance_to_mouse = mouse_pos_start.distance_to(mouse_pos)
				if distance_to_mouse > distance_to_edit:
					circle.activate()
					mouse_rotation = mouse_pos_start.angle_to_point(mouse_pos)
					circle.set_cursor_rotation(mouse_rotation)
					percentage = (rad_to_deg(mouse_rotation) + 180) / 360
					current_cd = max_spawn_cd * percentage
					circle.set_cd(current_cd)

func _leftclick_down_action(e: InputEvent) -> void:
	state = States.MouseDown
	mouse_pos_start = MouseObserver.get_mouse_pos()
	circle.set_global_position(mouse_pos_start)
	circle.set_color(ResourceManager.get_current_color()[1])

func _leftclick_up_action(e: InputEvent) -> void:
	state = States.MouseUp
	mouse_rotation = 0
	_create_emitter(mouse_pos_start)				
	percentage = -1
	circle.deactivate()

func _rightclick_down_action(e: InputEvent) -> void:
	var b: Emitter = _get_body_under_mouse(collision_mask, Emitter)
	if b:
		b.destroy()

func _rightclick_during_leftclick(e: InputEvent) -> void:
	# TODO: Move process to this method
	pass

func _create_emitter(p: Vector2) -> void:
	var cur_col: Array = ResourceManager.get_current_color()
	var cur_smp: Array = ResourceManager.get_current_sample()
	if !cur_col[0] || !cur_smp[0]:
		return
	# TODO: Remove direct access to parameters
	emitter = emitter_path.instantiate()
	emitter.parameters = EmitterResource.new()
	emitter.parameters.set_color(cur_col[1])
	emitter.parameters.set_sample(cur_smp[1])
	if percentage >= 0:
		emitter.parameters.set_cooldown(current_cd)
	else:
		emitter.parameters.set_cooldown(1)
	emitter.update_position(p)
	emitter.ball_pool = ball_pool
	emitter_pool.add_child(emitter)
