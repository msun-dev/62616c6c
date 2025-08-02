class_name PreviewBox
extends MarginContainer

@onready var label: Label = %Name
@onready var bgr: ColorRect = %BackgroundRect

const toggle_color: String = "#39b8a3"
const untoggle_color: String = "#007582"
const label_length: int = 10

var ui: UI = null
var type: int = -1
var index: int = -1
var selected := false
var mouse_inside := false

func _ready() -> void:
	GlobalSignalbus.ResourceRemoved.connect(_on_resource_removed)

func _input(event) -> void:
	if !mouse_inside:
		return
	if (event is InputEventMouseButton && 
		event.is_pressed() &&
		event.button_index == MOUSE_BUTTON_LEFT):
			select()	
	elif (event is InputEventMouseButton &&
		  event.is_pressed() &&
		  event.button_index == MOUSE_BUTTON_RIGHT):
			_remove()

func _remove() -> void:
	ResourceManager.remove_resource(type, index)
	queue_free()

func _on_resource_removed(t: int, i: int) -> void:
	match t:
		type:
			if i < index:
				index -= 1

func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false

func set_text(t: String) -> void:
	label.set_text(t.left(label_length))

func select() -> void:
	if selected:
		return
	selected = true
	ui.preview_selected(self)
	bgr.set_color(Color.from_string(toggle_color, Color.DEEP_PINK))

func unselect() -> void:
	selected = false
	bgr.set_color(Color.from_string(untoggle_color, Color.DEEP_PINK))

func set_type(t: int) -> void:
	type = t

func set_index(i: int) -> void:
	index = i

func set_ui(n: UI) -> void:
	ui = n

func get_type() -> int:
	return type

func get_i() -> int:
	return index
