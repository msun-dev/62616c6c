class_name Pool	
extends Node

func clear() -> void:
	for obj in self.get_children():
		obj.queue_free()
