extends Node

const sounds_ext: Array[StringName] = ["wav", "mp3", "ogg"]
const image_ext: Array[StringName] = ["png", "jpg", "jpeg"]

var palette: Array[Color] = []
var samples: Array[SampleResource] = []

var selected_color: int = -1
var selected_sample: int = -1

func _ready() -> void:
	get_window().files_dropped.connect(_on_files_dropped)

# Getters/Setters
# TODO: Add size check
func set_sample(i: int) -> void:
	selected_sample = i

# TODO: Add size check
func set_color(i: int) -> void:
	selected_color = i

func get_samples() -> Array[SampleResource]:
	return samples

func get_palette() -> Array[Color]:
	return palette

func get_current_sample() -> Array:
	if selected_sample != -1:
		return [1, samples[selected_sample]]
	else:
		return [0, 0]

func get_current_color() -> Array:
	if selected_color != -1:
		return [1, palette[selected_color]]
	else:
		return [0, 0]

func get_random_sample() -> SampleResource:
	return samples.pick_random() if samples.size() > 0 else null

func get_random_color() -> Color:
	return palette.pick_random() if palette.size() > 0 else null

# Class methods
func load_palette(image_path: String) -> void:
	# TODO: Add size check so user dont kill his device with huge ass palette (is this a palette even?)
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
				GlobalSignalbus.emit_signal("ColorAdded", color, palette.size() - 1)
	
# TODO: Play sample when loading to fix first sound not playing
func load_sound(sound_path: String) -> void:
	print_debug("Loading sound with given path: %s" % [sound_path])
	var sample := SampleResource.new()
	sample.set_sample_path(sound_path)
	sample.initiate_sample()
	samples.append(sample)
	GlobalSignalbus.emit_signal("SampleAdded", samples.back(), samples.size() - 1)

func save_data() -> void:
	# TODO: Implement
	pass

func load_data() -> void:
	# TODO: Implement
	pass

# SIGNALS
func _on_files_dropped(files) -> void:
	for file in files:
		var ext: StringName = file.get_extension()
		if ext in sounds_ext:
			load_sound(file)
		elif ext in image_ext:
			load_palette(file)
		else:
			printerr("The heck you dropped")
