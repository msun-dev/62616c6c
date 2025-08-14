#Honestly, I still don't understand resources
class_name SampleResource
extends Resource

@export var sample_path: String
@export var label: String
@export var stream: Resource = null

func initiate_sample(load_from_res: bool = 0) -> bool:
	# TODO: Add sample upload success check
	# NB: Use load() instead of load_from_file() to runtime load files in res:// dir.
	label = sample_path.get_file()
	if !load_from_res:
		match sample_path.get_extension():
			"wav":
				stream = AudioStreamWAV.load_from_file(sample_path)
				return true
			"mp3":
				stream = AudioStreamMP3.load_from_file(sample_path)
				return true
			"ogg":
				stream = AudioStreamOggVorbis.load_from_file(sample_path)
				return true
			_:
				printerr("No way this extension is here! (%s)" % [sample_path])
				return false
	else:
		stream = load(sample_path)
		return true

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
