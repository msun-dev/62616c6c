class_name ResourceManager
extends Node

const sounds_ext = [".wav", ".mp3", ".ogg"]

var palette_image: Resource = null

static func load_palette(image_path: String) -> Array[Color]:
	if !image_path:
		return []
	print_debug("Loading palette at path: %s" % [image_path])
	var image: Image = Image.load_from_file(image_path)
	await image != null
	#if image == null:
		#printerr("Couldn't load an image provided")
		#return []
	var size: Vector2i = image.get_size()
	var palette: Array[Color] = []
	for x in size.x:
		for y in size.y:
			var color: Color = image.get_pixel(x, y)
			if color != Color.BLACK && !palette.has(color):
				palette.append(color)
	return palette

static func get_sounds_list(sounds_path: String) -> Array:
	# Get dir
	# Iterate over it
	# 	Create audioplayer node for every sound found
	# ??? Return list with loaded sounds

	var dir: DirAccess = DirAccess.open(sounds_path)
	if !dir:
		return []
	var sounds: Array = []
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			continue
		file_name = dir.get_next()
		sounds.append(file_name)
	return sounds

static func save_layout() -> void:
	pass
