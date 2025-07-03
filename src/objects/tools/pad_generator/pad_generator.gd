extends Tool

@export var min_size: float = 10.
@export var debug_draw: bool = false
@export var pad_pool: Node = null

var state: States = States.MouseUp
var pad_child: Pad = null

var PadPath: Resource = preload("res://src/objects/pad/pad.tscn")
var PadNode: Pad = null

enum States {
	MouseUp,
	MouseDown,
}

func _init() -> void:
	super()
	PadNode = PadPath.instantiate()
	disabled = false # TODO: REMOVE

func _unhandled_input(event) -> void:
	if disabled:
		return
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if pad_child == null && event.is_pressed():
			state = States.MouseDown
			_create_pad(MouseObserver.get_mouse_pos())
		elif pad_child && !event.is_pressed():
			state = States.MouseUp
			pad_pool.add_child(pad_child)
			pad_child.set_active()
			pad_child = null

func _process(delta) -> void:
	if pad_child && state == States.MouseDown:
		var mouse_pos = MouseObserver.get_mouse_pos()
		pad_child.update_position(1, mouse_pos)

func _create_pad(p: Vector2) -> void:	
	pad_child = PadPath.instantiate()
	pad_child.parameters = PadResource.new()
	pad_child.update_position(0, p)
