class_name ColorPreviewBox
extends PreviewBox

@onready var image: TextureRect = %Image

func set_image(i: Texture2D) -> void:
	image.set_texture(i)
