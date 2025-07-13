extends Tool

@onready var deleter: Area2D = %Deleter

@export var emitter_pool: Pool
@export var ball_pool: Pool

const type: int = 1
const emitter_path: Resource = preload("res://src/objects/emitter/emitter.tscn")

var emitter: Emitter = null

func _ready() -> void:
	GlobalSignalbus.ToolSelected.connect(_on_tool_selected)

func _unhandled_input(event) -> void:
	if disabled:
		return
	if (event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_LEFT):
		_create_emitter(MouseObserver.get_mouse_pos())
		
	if (event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_RIGHT):
		var b: Emitter = _get_body_under_mouse(0x0002, Emitter)
		if b:
			b.destroy()

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
	emitter.update_position(MouseObserver.get_mouse_pos())
	emitter.ball_pool = ball_pool
	emitter_pool.add_child(emitter)

func _on_tool_selected(t: int) -> void:
	if t == type:
		set_disabled(false)
	else:
		set_disabled(true)
