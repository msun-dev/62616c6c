extends Node

'''
There is a polyphony thing that allows to play million sounds at once.
Probably had to instance these samples at once and use play method instead
of instancing sample players. 

TODO: Replace instancing with polyphony
'''

func play_sample(s: SampleResource) -> void:
	if !s:
		printerr("Tried to play sample with no sample provided!")
	var sound := AudioStreamPlayer.new()
	sound.set_stream(s.get_stream())
	sound.finished.connect(Callable(self, "_on_player_finish").bind(sound))
	add_child(sound)
	sound.play()

func play_sample_at(s: SampleResource, p: Vector2) -> void:
	if !s || !p:
		printerr("Tried to play sample with no sample or position provided!")
	var sound := AudioStreamPlayer2D.new()
	sound.set_stream(s.get_stream())
	sound.set_global_position(p)
	sound.finished.connect(Callable(self, "_on_player_finish").bind(sound))
	add_child(sound)
	sound.play()

func stopsounds() -> void:
	for player in get_children():
		player.queue_free()

func _on_player_finish(p: Variant) -> void:
	if p is AudioStreamPlayer or p is AudioStreamPlayer2D:
		p.queue_free()
	else:
		printerr("Tried to free an object that is not AudioStreamPlayer(2D)!")
