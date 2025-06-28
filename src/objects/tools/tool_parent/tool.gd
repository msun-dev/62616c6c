class_name Tool
extends Node

@export var icon_path: String
@export var disabled: bool = true

var icon: Texture2D

func _init() -> void:
	if icon_path:
		icon = load(icon_path)

func set_disabled(d: bool) -> void:
	disabled = d 

func is_disabled() -> bool:
	return disabled
