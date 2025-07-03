extends Control

func _process(delta):
	%mouse_pos.set_text("Mouse pos: %s" % [MouseObserver.get_mouse_pos()])
	
