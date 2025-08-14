class_name Tool
extends Node

@export var icon_path: String

enum States {
	MouseUp,
	MouseDown,
}

var type: int = -1
var state: States = States.MouseUp
var disabled: bool = true
var icon: Texture2D

func _init() -> void:
	if icon_path:
		icon = load(icon_path)

func _ready() -> void:
	GlobalSignalbus.ToolSelected.connect(_on_tool_selected)

# UNDONE: Moved logic to unhandled input. 
func _unhandled_input(event: InputEvent) -> void:
	if disabled:
		return
	
	if (event is InputEventMouseButton &&
		state == States.MouseUp &&
		event.button_index == MOUSE_BUTTON_LEFT &&
		event.is_pressed()):
			_leftclick_down_action(event)			
	
	if (event is InputEventMouseButton &&
		state == States.MouseDown &&
		event.button_index == MOUSE_BUTTON_LEFT &&
		event.is_released()):
			_leftclick_up_action(event)
	
	if (state == States.MouseDown &&
		event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_RIGHT):
			_rightclick_during_leftclick(event)
	
	if (state == States.MouseUp &&
		event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_RIGHT):
			_rightclick_down_action(event)

func _leftclick_down_action(e: InputEvent) -> void:
	pass

func _leftclick_up_action(e: InputEvent) -> void:
	pass

func _rightclick_down_action(e: InputEvent) -> void:
	pass

func _rightclick_up_action(e: InputEvent) -> void:
	pass

func _rightclick_during_leftclick(e: InputEvent) -> void:
	pass

func _get_body_under_mouse(mask: int, t: Variant) -> Variant:
	var q := PhysicsPointQueryParameters2D.new()
	q.set_collide_with_bodies(false)
	q.set_collide_with_areas(true)
	q.set_collision_mask(mask)
	q.position = MouseObserver.get_mouse_pos()
	var w: PhysicsDirectSpaceState2D = get_viewport().get_world_2d().get_direct_space_state()
	var b: Array[Dictionary] = w.intersect_point(q)
	if len(b) > 0:
		var n = b.back()["collider"].get_parent()
		if is_instance_of(n, t):
			return n
		else:
			return null
	else:
		return null
	@warning_ignore("unreachable_code")
	'''
	Yeah but nulls are 3rd party thing and idk.
	
	I learned that you can return nulls in Java, though that every lang does that.
	But after reading C lang book I found out that that thing is only(mostly) 
	feature of Java lang.
	And also returning null is kinda bad. Don't do that!
	'''

func _on_tool_selected(t: int) -> void:
	if t == type:
		set_disabled(false)
	else:
		set_disabled(true)

func set_disabled(d: bool) -> void:
	disabled = d
	#set_process(d)
	#set_process_input(d)

func is_disabled() -> bool:
	return disabled
