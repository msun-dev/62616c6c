extends Tool

@export var pad_pool: Pool = null

const type: int = 0
const PadPath: Resource = preload("res://src/objects/pad/pad.tscn")
const min_size: float = 10.

enum States {
	MouseUp,
	MouseDown,
}

var state: States = States.MouseUp
var pad_child: Pad = null
var PadNode: Pad = null

var a: Vector2
var b: Vector2


func _init() -> void:
	super()
	PadNode = PadPath.instantiate()

func _ready() -> void:
	GlobalSignalbus.ToolSelected.connect(_on_tool_selected)

'''
uhm...
'''
func _unhandled_input(event) -> void:
	if disabled:
		return
	
	if (event is InputEventMouseButton && 
		event.button_index == MOUSE_BUTTON_LEFT):
		if pad_child == null && event.is_pressed():
			state = States.MouseDown
			a = MouseObserver.get_mouse_pos()
			_create_pad(a)
		elif pad_child && !event.is_pressed():
			state = States.MouseUp
			if a.distance_to(b) > min_size:
				pad_child.reparent(pad_pool)
				pad_child.set_active()
			else:
				pad_child.queue_free()
			pad_child = null
	
	if (state == States.MouseDown &&
		pad_child &&
		event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_RIGHT):
		state = States.MouseUp
		pad_child.queue_free()
		pad_child = null
		return
	
	if (state == States.MouseUp &&
		event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_RIGHT):
		var b: Pad = _get_body_under_mouse(0x0001, Pad)
		if b:
			b.destroy()
	
func _process(delta) -> void:
	if pad_child && state == States.MouseDown:
		b = MouseObserver.get_mouse_pos()
		pad_child.update_position(1, b)

func get_state() -> String:
	return States.keys()[state]

func _create_pad(p: Vector2) -> void:
	var cur_col = ResourceManager.get_current_color()
	if cur_col[0] == 0:
		return
	
	pad_child = PadPath.instantiate()
	pad_child.parameters = PadResource.new()
	pad_child.parameters.set_color(cur_col[1])
	pad_child.update_position(0, p)
	add_child(pad_child)

func _on_tool_selected(t: int) -> void:
	if t == type:
		set_disabled(false)
	else:
		set_disabled(true)
