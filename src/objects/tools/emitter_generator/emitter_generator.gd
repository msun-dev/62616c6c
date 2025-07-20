extends Tool

@onready var circle: CircleNode = $CircleNode

@export var emitter_pool: Pool
@export var ball_pool: Pool

const type: int = 1
const emitter_path: Resource = preload("res://src/objects/emitter/emitter.tscn")
const distance_to_edit: float = 25.
const min_spawn_cd: float = 0.1
const max_spawn_cd: float = 10.
const collision_mask: int = 0x0002

enum MouseStates {
	MouseUp = 0,
	MouseDown = 1
}

var emitter: Emitter = null
var mouse_state := MouseStates.MouseUp
var mouse_rotation: float = 0.
var mouse_pos_start := Vector2.ZERO
var mouse_pos := Vector2.ZERO
var distance_to_mouse: float = 0.
var rotation_to_mouse: float = 0.
var percentage: float = -1.
var current_cd: float = max_spawn_cd

func _ready() -> void:
	GlobalSignalbus.ToolSelected.connect(_on_tool_selected)

func _unhandled_input(event) -> void:
	if disabled:
		return
	
	if (event is InputEventMouseButton &&
		mouse_state == MouseStates.MouseUp &&
		event.button_index == MOUSE_BUTTON_LEFT &&
		event.is_pressed()):
			# doing something once when mouse pressed:
			mouse_state = MouseStates.MouseDown
			mouse_pos_start = MouseObserver.get_mouse_pos()
			circle.set_global_position(mouse_pos_start)
			circle.set_color(ResourceManager.get_current_color()[1])
			
	elif (event is InputEventMouseButton &&
		mouse_state == MouseStates.MouseDown &&
		event.button_index == MOUSE_BUTTON_LEFT &&
		event.is_released()):
			# doing something once when mouse released:
			mouse_state = MouseStates.MouseUp
			mouse_rotation = 0
			_create_emitter(mouse_pos_start)				
			percentage = -1
			circle.deactivate()
			
	elif (event is InputEventMouseButton && 
		event.button_index == MOUSE_BUTTON_RIGHT &&
		event.is_pressed()):
			var b: Emitter = _get_body_under_mouse(collision_mask, Emitter)
			if b:
				b.destroy()

func _process(delta) -> void:
	match mouse_state:
		MouseStates.MouseUp:
			pass
		MouseStates.MouseDown:
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

func _on_tool_selected(t: int) -> void:
	if t == type:
		set_disabled(false)
	else:
		set_disabled(true)
