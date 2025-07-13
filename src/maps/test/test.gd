extends Node

func _ready():
	ResourceManager.load_palette("res://assets/spooky6-1x.png")
	ResourceManager.load_sound("res://assets/bass-dry.wav")
	ResourceManager.load_sound("res://assets/normal-hitclap.wav")

	GlobalSignalbus.emit_signal("ToolSelected", 0)
