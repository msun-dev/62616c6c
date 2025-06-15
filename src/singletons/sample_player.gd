extends Node

func _input(event) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		var sample: SampleResource = ResourceManager.get_random_sample()
		if sample: 
			play_sample(sample)

func play_sample(s: SampleResource) -> void:
	var sound := AudioStreamPlayer.new()
	sound.set_stream(s.get_stream())
	sound.finished.connect(Callable(self, "_on_player_finish").bind(sound))
	add_child(sound)
	sound.play()

func play_sample_at(s: SampleResource, p: Vector2) -> void:
	var sound := AudioStreamPlayer2D.new()
	sound.set_stream(s.get_stream())
	sound.set_global_position(p)
	add_child(sound)
	sound.play()

func stopsounds() -> void:
	for player in get_children():
		player.queue_free()

func _on_player_finish(p: AudioStreamPlayer) -> void:
	print("")
	p.queue_free()
