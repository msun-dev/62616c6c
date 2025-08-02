# DONE: Implemented
class_name ButtonComponent
extends Node

var parent: Control = null

func _ready() -> void:
	parent = get_parent()
	if !parent.has_method("select") or !parent.has_method("unselect"):
		printerr("There is no select/unselect method in the parent! Deleting myself!")
		queue_free()
	
	_connect_signals()
	
func _connect_signals() -> void:
	parent.mouse_entered.connect(_on_mouse_enter)
	parent.mouse_exited.connect(_on_mouse_exit)
	
func _on_mouse_enter() -> void:
	parent.select()

func _on_mouse_exit() -> void:
	parent.unselect()
