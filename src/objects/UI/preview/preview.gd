class_name PreviewBoxSample
extends MarginContainer

@onready var image: TextureRect = %Image
@onready var label: Label = %Name

var label_length: int = 10

func set_image(i: Texture2D) -> void:
	image.set_texture(i)

func set_text(t: String) -> void:
	label.set_text(t.left(label_length))
