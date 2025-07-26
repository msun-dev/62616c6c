#Honestly, I still don't understand resources
class_name SampleResource
extends Resource

@export var sample_path: String
@export var label: String

var stream: Resource = null

func initiate_sample() -> bool:
	# TODO: Add filepath check
	# NB: Use load() instead of load_from_file() to runtime load files in res:// dir.
	label = sample_path.get_file()
	match sample_path.get_extension():
		"wav":
			stream = load(sample_path)
			return true
		"mp3":
			stream = load(sample_path)
			return true
		"ogg":
			stream = load(sample_path)
			return true
		_:
			printerr("No way this extension is here! (%s)" % [sample_path])
			return false

func instance() -> AudioStreamPlayback:
	return stream.instantiate_playback()

func set_sample_path(p: String) -> void:
	sample_path = p

func set_label(l: String) -> void:
	label = l

func get_stream() -> AudioStream:
	return stream

func get_label() -> String:
	return label.get_basename()
