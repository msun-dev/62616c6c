class_name Pool	
extends Node

func clear() -> void:
	for obj in self.get_children():
		obj.destroy()

func get_amount() -> int:
	return get_child_count()

func execute_method_on_pool(m: Callable) -> void:
	for obj in self.get_children():
		m.call(obj)
