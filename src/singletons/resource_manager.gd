extends Node

const sounds_ext: Array[StringName] = ["wav", "mp3", "ogg"]
const image_ext: Array[StringName] = ["png", "jpg", "jpeg"]

var palette: Array[Color] = []
var samples: Array[Sample] = []

func _ready() -> void:
	get_window().files_dropped.connect(_on_files_dropped)

func load_palette(image_path: String) -> void:
	print_debug("Loading palette with given path: %s" % [image_path])
	if !image_path:
		return 
	var image: Image = Image.load_from_file(image_path)
	var size: Vector2i = image.get_size()
	palette = []
	for x in size.x:
		for y in size.y:
			var color: Color = image.get_pixel(x, y)
			if color != Color.BLACK && !palette.has(color):
				palette.append(color)

func load_sound(sound_path: String) -> void:
	print_debug("Loading sound with given path: %s" % [sound_path])
	var sample := Sample.new()
	sample.initiate_sample(sound_path)
	samples.append(sample)

func _on_files_dropped(files) -> void:
	for file in files:
		var ext: StringName = file.get_extension()
		if ext in sounds_ext:
			load_sound(file)
		elif ext in image_ext:
			load_palette(file)
		else:
			printerr("The heck you dropped")

func get_random_sample() -> Sample:
	return samples.pick_random() if samples.size() > 0 else null
