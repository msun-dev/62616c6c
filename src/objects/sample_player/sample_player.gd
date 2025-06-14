class_name SamplePlayer
extends Node

func _input(event) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		play_sample(ResourceManager.get_random_sample())

func play_sample(s: Sample) -> void:
	var sound := AudioStreamPlayer.new()
	sound.set_stream(s.get_stream())
	add_child(sound)
	sound.play()

func play_sample_at(s: Sample, p: Vector2) -> void:
	var sound := AudioStreamPlayer2D.new()
	sound.set_stream(s.get_stream())
	sound.set_global_position(p)
	add_child(sound)
	sound.play()

func stopsounds() -> void:
	for player in get_children():
		player.queue_free()
