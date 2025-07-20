class_name PreviewBoxSample
extends MarginContainer

const toggle_color: String = "#39b8a3"
const untoggle_color: String = "#007582"
const label_length: int = 10

@onready var image: TextureRect = %Image
@onready var label: Label = %Name
@onready var bgr: ColorRect = %BackgroundRect
@onready var button: Button = %Button

var type: int = -1 
var index: int = -1
var selected: bool = false

func set_image(i: Texture2D) -> void:
	image.set_texture(i)

func set_text(t: String) -> void:
	label.set_text(t.left(label_length))

func set_type(t: int) -> void:
	type = t

func set_index(i: int) -> void:
	index = i

func get_type() -> int:
	return type

func get_i() -> int:
	return index

func select() -> void:
	if selected:
		return
	selected = true
	bgr.set_color(Color.from_string(toggle_color, Color.DEEP_PINK))

func unselect() -> void:
	if !selected:
		return
	selected = false
	bgr.set_color(Color.from_string(untoggle_color, Color.DEEP_PINK))
