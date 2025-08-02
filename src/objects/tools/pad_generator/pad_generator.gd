extends Tool

@export var pad_pool: Pool = null

const min_size: float = 10.

var PadPaths: Array[String] = [
	"res://src/objects/pad/pad.tscn",
	"res://src/objects/pad/slow_pad/slow_pad.tscn",
	"res://src/objects/pad/speedup_pad/speedup_pad.tscn",
]

var current_type = 2
var pad_child: Pad = null
var PadNode: Pad = null
var a: Vector2
var b: Vector2

func _init() -> void:
	super()
	
	type = 0

func _ready() -> void:
	super()
	
	GlobalSignalbus.PadTypeSelected.connect(_on_pad_type_selected)

func _unhandled_input(event: InputEvent) -> void:
	if ResourceManager.get_current_color()[0] != 0:
		super(event)
	else:
		# TODO: Throw UI error
		pass
	
func _process(delta) -> void:
	if pad_child && state == States.MouseDown:
		b = MouseObserver.get_mouse_pos()
		pad_child.update_position(1, b)

func _leftclick_down_action(event: InputEvent) -> void:
	if !pad_child:
		state = States.MouseDown
		a = MouseObserver.get_mouse_pos()
		_create_pad(a)

func _leftclick_up_action(event: InputEvent) -> void:
	if pad_child:
		state = States.MouseUp
		if a.distance_to(b) > min_size:
			pad_child.reparent(pad_pool)
			pad_child.set_active()
		else:
			pad_child.queue_free()
		pad_child = null

func _rightclick_down_action(event: InputEvent) -> void:
	var body: Pad = _get_body_under_mouse(0x0001, Pad)
	if body:
		body.destroy()

func _rightclick_up_action(event: InputEvent) -> void:
	pass

func _rightclick_during_leftclick(event: InputEvent) -> void:
	if pad_child:
		state = States.MouseUp
		pad_child.queue_free()
		pad_child = null

func _create_pad(p: Vector2) -> void:
	var cur_col = ResourceManager.get_current_color()
	if cur_col[0] == 0:
		return
	
	pad_child = load(PadPaths[current_type]).instantiate()
	pad_child.parameters = PadResource.new()
	pad_child.parameters.set_color(cur_col[1])
	pad_child.update_position(0, p)
	add_child(pad_child)

func _on_pad_type_selected(t: int) -> void:
	current_type = t

func get_state() -> String:
	return States.keys()[state]
