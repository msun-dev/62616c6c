class_name Sample
extends Node

@export var sample_path: String
@export var label: String
@export var color: Color
var loaded_sample: AudioStream

func initiate_sample(p: String, l: String, c: Color) -> void:
	sample_path = p
	label = l
	color = c
	preload_sample()

func generate_color() -> void:
	color = Color( 
		float(sample_path.hash() % 100) / 100,
		float(sample_path.hash() % 10000) / 10000,
		float(sample_path.hash() % 1000000) / 1000000,
	)

func preload_sample() -> void:
	if !sample_path:
		printerr("Tried to preload sample with no sample_path!")
	
	loaded_sample = AudioStream.new()

func set_color(c: Color) -> void:
	color = c

func set_label(l: String) -> void:
	label = l

func _get_sample_ext() -> String:
	pass
