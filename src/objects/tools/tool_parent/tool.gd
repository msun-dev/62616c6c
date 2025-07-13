class_name Tool
extends Node

@export var icon_path: String
@export var disabled: bool = true

var icon: Texture2D

func _init() -> void:
	if icon_path:
		icon = load(icon_path)

func _get_body_under_mouse(mask: int, type: Variant) -> Variant:
	var q := PhysicsPointQueryParameters2D.new()
	q.set_collide_with_bodies(false)
	q.set_collide_with_areas(true)
	q.set_collision_mask(mask)
	q.position = MouseObserver.get_mouse_pos()
	var w: PhysicsDirectSpaceState2D = get_viewport().get_world_2d().get_direct_space_state()
	var b: Array[Dictionary] = w.intersect_point(q)
	if len(b) > 0:
		var n = b.back()["collider"].get_parent()
		if is_instance_of(n, type):
			return n
		else:
			return null
	else:
		return null
	'''
	Yeah but nulls are 3rd party thing and idk.
	
	I learned that you can return nulls in Java, though that every lang does that.
	But after reading C lang book I found out that that thing is only(mostly) 
	feature of Java lang.
	And also returning null is kinda bad. Don't do that!
	'''

func set_disabled(d: bool) -> void:
	disabled = d 

func is_disabled() -> bool:
	return disabled
