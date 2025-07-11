'''
I don't like that in order to get mouse position you have to
create a node that inherits CanvasItem. So thats the solution
I came up with. Probably you can come up with something better,
but thats all I can do. :( 
	
Also there was like 4 vars in calculate_mouse_pos() but I decided
to shrunk it a bit (to 1). Hope it decreases process time for a bit. 
'''

extends Node

var mouse_pos: Vector2i = Vector2i.ZERO

func _process(delta):
	calculate_mouse_pos()

# TODO: Fix so it gets position on the canvas instead of screen
func calculate_mouse_pos() -> void:
	var nmp: Vector2i = DisplayServer.mouse_get_position() - DisplayServer.window_get_position()
	mouse_pos = nmp.clamp(Vector2i.ZERO, DisplayServer.window_get_size())

func get_mouse_pos() -> Vector2i:
	return mouse_pos
