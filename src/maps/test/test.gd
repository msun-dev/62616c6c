extends Node

func _ready():
	GlobalSignalbus.emit_signal("ToolSelected", 0)
