extends Node

const SoundsExt: Array[StringName] = ["wav", "mp3", "ogg"]
const ImageExt: Array[StringName] = ["png", "jpg", "jpeg"]
const MaxPaletteSize: int = 999999 # :O

var palette: Array[Color] = []
var samples: Array[SampleResource] = []
var selected_color: int = -1
var selected_sample: int = -1

func _ready() -> void:
	get_window().files_dropped.connect(_on_files_dropped)
	
	# HACK
	_load_color(Color.from_string("#27234c", Color.DEEP_PINK))
	_load_color(Color.from_string("#733c7c", Color.DEEP_PINK))
	_load_color(Color.from_string("#b296ff", Color.DEEP_PINK))
	_load_color(Color.from_string("#d3d37c", Color.DEEP_PINK))
	_load_color(Color.from_string("#e88dc3", Color.DEEP_PINK))
	_load_color(Color.from_string("#f2504b", Color.DEEP_PINK))
	_load_color(Color.from_string("#225091", Color.DEEP_PINK))
	#load_palette("res://assets/palette/mushfairy-1x.png")
	
	_load_sample("res://assets/samples/HiHat.wav", true)
	_load_sample("res://assets/samples/KickDrum.wav", true)
	_load_sample("res://assets/samples/SnareDrum1.wav", true)
	_load_sample("res://assets/samples/SnareDrum2.wav", true)
	_load_sample("res://assets/samples/SnareDrum3.wav", true)
	_load_sample("res://assets/samples/SnareDrum4.wav", true)

func _on_files_dropped(files) -> void:
	for file in files:
		var ext: StringName = file.get_extension()
		if ext in SoundsExt:
			_load_sample(file)
		elif ext in ImageExt:
			_load_palette(file)
		else:
			printerr("The heck you dropped")

func _load_sample(sound_path: String, from_res: bool = 0) -> void:
	print_debug("Loading sound with given path: %s" % [sound_path])
	var sample := SampleResource.new()
	sample.set_sample_path(sound_path)
	if !sample.initiate_sample(from_res):
		# TODO: Emit UI error: (Couldn't load sample!)
		pass
	samples.append(sample)
	GlobalSignalbus.emit_signal("SampleAdded", samples.back(), samples.size() - 1)

func _load_palette(image_path: String) -> void:
	# 2 KiB max, enough for small palettes (<=256 colors)
	# TODO: Add size check so user dont kill his device with huge ass palette 
	# (is this a palette even?)
	
	var file = FileAccess.get_file_as_bytes(image_path)
	
	
	var image: Image = Image.load_from_file(image_path)
	if !image:
		printerr("Image load failed.")
		return
	print_debug("Loading palette with given path: %s" % [image_path])
	var size: Vector2i = image.get_size()
	palette = []
	for x in size.x:
		for y in size.y:
			var color: Color = image.get_pixel(x, y)
			if color != Color.BLACK && !palette.has(color):
				palette.append(color)
				GlobalSignalbus.emit_signal("ColorAdded", color, palette.size() - 1)

func _load_color(c: Color) -> void:
	palette.append(c)
	GlobalSignalbus.emit_signal("ColorAdded", c, palette.size() - 1)

func remove_resource(t: int, i: int) -> void:
	# Maybe delete emitters with that resource also?
	match t:
		0:
			samples.remove_at(i)
			if i == selected_sample:
				selected_sample = -1
		1:
			palette.remove_at(i)
			if i == selected_color:
				selected_color = -1
	GlobalSignalbus.ResourceRemoved.emit(t, i)
	print_debug("Resource removed: type: %d, index: %d" % [t, i])

# Getters/Setters
# LTODO: Add size check
func select_sample(i: int) -> void:
	selected_sample = i

# LTODO: Add size check
func select_color(i: int) -> void:
	selected_color = i

func get_samples() -> Array[SampleResource]:
	return samples

func get_palette() -> Array[Color]:
	return palette

# TODO: Remove that shit, left as -1 if -1, no need for array
# And, cant come up with the solution :/
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

func are_both_selected() -> bool:
	return selected_sample > -1 && selected_color > -1
