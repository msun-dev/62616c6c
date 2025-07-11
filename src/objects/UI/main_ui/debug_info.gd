extends Control

func _input(event) -> void:
	if (event is InputEventKey &&
		event.is_pressed() &&
		event.get_keycode() == KEY_D):
		set_visible(!is_visible())
		set_process(is_visible())

func _process(delta) -> void:
	%mouse_pos.set_text("Mouse pos: %s" % [MouseObserver.get_mouse_pos()])
	
