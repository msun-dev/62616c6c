extends Tool

@export var min_size: float = 10.
@export var debug_draw: bool = false
@export var pad_pool: Node = null

var PadPath: Resource = preload("res://src/objects/pad/pad.tscn")
var PadNode: Pad = null
var state: States = States.MouseUp
var pad_child: Pad = null

enum States {
	MouseUp,
	MouseDown,
}

func _init() -> void:
	super()
	PadNode = PadPath.instantiate()

func _input(event) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if pad_child == null && event.is_pressed():
			state = States.MouseDown
			create_pad(MouseObserver.get_mouse_pos())
		elif pad_child && !event.is_pressed():
			state = States.MouseUp
			pad_child.set_active(debug_draw)
			pad_pool.reparent_object(pad_child)
			pad_child = null

func _process(delta) -> void:
	if pad_child && state == States.MouseDown:
		var mouse_pos = MouseObserver.get_mouse_pos()
		pad_child.set_second_point(mouse_pos)

func create_pad(p: Vector2) -> void:
	ResourceManager.get
	
	pad_child = PadPath.instantiate()
	pad_child.update_position(0, p)
