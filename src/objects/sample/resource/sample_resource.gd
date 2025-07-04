'''
Honestly, I still don't understand resources
'''

class_name SampleResource
extends Resource

@export var sample_path: String
@export var label: String
var stream: AudioStream

func _init() -> void:
	initiate_sample()

func initiate_sample() -> void:
	label = sample_path.get_file() #str(sample_path.hash() % 1000000)
	preload_sample()

func preload_sample() -> void:
	#if !sample_path:
		#printerr("Tried to preload sample with no sample_path!")
		#return
	match sample_path.get_extension():
		"wav":
			stream = AudioStreamWAV.load_from_file(sample_path)
		"mp3":
			stream = AudioStreamMP3.load_from_file(sample_path)
		"ogg":
			stream = AudioStreamOggVorbis.load_from_file(sample_path)
		_:
			printerr("No way this extension is here! (%s)" % [sample_path])

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
