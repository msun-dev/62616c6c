extends Control

func _ready():
	GlobalSignalbus.SampleAdded.connect(_on_sample_added)
	GlobalSignalbus.ColorAdded.connect(_on_color_added)

func _on_sample_added(s: SampleResource) -> void:
	pass

func _on_color_added(c: Color) -> void:
	pass

func add_preview(t: int) -> void:
	match t:
		0:
			pass
		1:
			pass

func create_preview_node() -> void:
	pass
