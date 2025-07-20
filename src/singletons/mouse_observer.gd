'''
I don't like that in order to get mouse position you have to
create a node that inherits CanvasItem. So thats the solution
I came up with. Probably you can come up with something better,
but thats all I can do. :(
	
Also there was like 4 vars in calculate_mouse_pos() but I decided
to shrunk it a bit (to 1). Hope it decreases process time for a bit. 

...

(You can check out that abomination in git history!)

And you can just use viewport and get mouse position from it. Simple! 
'''

extends Node

var mouse_pos: Vector2i = Vector2i.ZERO

func _process(delta) -> void:
	_calculate_mouse_pos()

func _calculate_mouse_pos() -> void:
	var vp := get_viewport()
	if !vp:
		return
	mouse_pos = vp.get_mouse_position()

func get_mouse_pos() -> Vector2i:
	return mouse_pos
