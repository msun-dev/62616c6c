extends Tool

@onready var deleter: Area2D = $Deleter

@export var debug_draw: bool = false
@export var pad_pool: Node = null

const type: int = 0
const PadPath: Resource = preload("res://src/objects/pad/pad.tscn")
const min_size: float = 10.

var state: States = States.MouseUp
var pad_child: Pad = null
var PadNode: Pad = null
var a: Vector2
var b: Vector2

enum States {
	MouseUp,
	MouseDown,
}

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
	
	# TODO: Fix/rework
	if (state == States.MouseUp &&
		event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_RIGHT):
		#var q := PhysicsPointQueryParameters2D.new()
		#q.position = MouseObserver.get_mouse_pos()
		#var w := World2D.new()
		#var b = w.get_direct_space_state().intersect_point(q)
		#print(b) #????
		deleter.set_global_position(MouseObserver.get_mouse_pos())
		var bs = deleter.get_overlapping_bodies()
		var o = bs.front()
		if o && o.get_parent() is Pad:
			o.get_parent().destroy()
	
func _process(delta) -> void:
	if pad_child && state == States.MouseDown:
		b = MouseObserver.get_mouse_pos()
		pad_child.update_position(1, b)

func _physics_process(delta) -> void:
	pass

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
