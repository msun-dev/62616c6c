extends Control

func _input(event) -> void:
	pass # TODO: Add toggle option

func _process(delta) -> void:
	%mouse_pos.set_text("Mouse pos: %s" % [MouseObserver.get_mouse_pos()])
	
