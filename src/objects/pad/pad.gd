'''
I don't really like how positions in godot are handled.
For this project in this pad object, for example, I have to 
create a Pad with pos_a that starts at mouse position.....

Wait, maybe I'm wrong...

- [x] TODO: Update this comment

There are to_global and to_local methods exist. Check them out! 
'''
class_name Pad
extends Node2D

@export var parameters: PadResource

@onready var collision: StaticBody2D = $StaticBody

func _ready() -> void:
	pass

func update_position(i: int, p: Vector2) -> void:
	parameters.set_pos(i, p)
	
func update_collision() -> void:
	pass
