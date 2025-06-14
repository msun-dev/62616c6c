extends Node

const sounds_ext: Array[StringName] = ["wav", "mp3", "ogg"]
const image_ext: Array[StringName] = ["png", "jpg", "jpeg"]

var palette: Array[Color] = []
var samples: Array[Sample] = []

func _ready() -> void:
	get_window().files_dropped.connect(_on_files_dropped)

func save_layout() -> void:
	pass

func load_palette(image_path: String) -> void:
	if !image_path:
		return 
	print_debug("Loading palette at path: %s" % [image_path])
	var image: Image = Image.load_from_file(image_path)
	image != null
	#if image == null:
		#printerr("Couldn't load an image provided")
		#return []
	var size: Vector2i = image.get_size()
	palette = []
	for x in size.x:
		for y in size.y:
			var color: Color = image.get_pixel(x, y)
			if color != Color.BLACK && !palette.has(color):
				palette.append(color)

func load_sound(sound_path: String) -> void:
	# Get dir
	# Iterate over it
	# 	Create audioplayer node for every sound found
	# ??? Return list with loaded sounds
	print_debug("Loading sound at path: %s" % [sound_path])
	
	#var dir: DirAccess = DirAccess.open(sounds_path)
	#if !dir:
		#return []
	#var sounds: Array = []
	#dir.list_dir_begin()
	#var file_name: String = dir.get_next()
	#while file_name != "":
		#if dir.current_is_dir():
			#continue
		#file_name = dir.get_next()
		#sounds.append(file_name)
	#return sounds

func _on_files_dropped(files) -> void:
	for file in files:
		var ext: StringName = file.get_extension()
		if ext in sounds_ext:
			load_sound(file)
		elif ext in image_ext:
			load_palette(file)
		else:
			printerr("The heck you dropped")
	
