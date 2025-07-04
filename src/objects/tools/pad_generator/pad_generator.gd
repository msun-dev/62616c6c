extends Tool

@onready var deleter: Area2D = $Deleter

@export var min_size: float = 10.
@export var debug_draw: bool = false
@export var pad_pool: Node = null

var state: States = States.MouseUp
var pad_child: Pad = null
var a: Vector2
var b: Vector2

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

	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT:
		deleter.set_global_position(MouseObserver.get_mouse_pos())
		var b = deleter.get_overlapping_bodies()
		var o = b.front()
		if o && o.get_parent() is Pad:
			o.get_parent().destroy()

func _process(delta) -> void:
	if pad_child && state == States.MouseDown:
		b = MouseObserver.get_mouse_pos()
		pad_child.update_position(1, b)

func _create_pad(p: Vector2) -> void:	
	pad_child = PadPath.instantiate()
	pad_child.parameters = PadResource.new()
	pad_child.update_position(0, p)
	add_child(pad_child)
