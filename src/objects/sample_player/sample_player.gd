class_name SamplePlayer
extends Node

func play_sample(sample: Sample) -> void:
	#var sound = AudioStreamPlayer.new()
	#sound.set_stream(sample)
	pass

func play_sample_at() -> void:
	pass

func stopsounds() -> void:
	for player in get_children():
		player.queue_free()
