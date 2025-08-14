extends Node

@onready var bg: ColorRect = $ColorRect
@onready var preload_nodes: Array = [
	# Pads
	preload("res://src/objects/pad/pad.tscn"),
	preload("res://src/objects/pad/slow_pad/slow_pad.tscn"),
	preload("res://src/objects/pad/speedup_pad/speedup_pad.tscn"),
	# Balls
	preload("res://src/objects/ball/ball.tscn"),
]

const preload_paths_particles: Array[String] = [
	"res://src/objects/ball/ball_collision_particle.tscn",
	"res://src/objects/emitter/particle_death.tscn",
	"res://src/objects/pad/particle_death.tscn"
]
const main_scene: String = "res://src/maps/empty/empty.tscn"

func _ready() -> void:
	bg.set_color(ProjectSettings.get_setting("rendering/environment/defaults/default_clear_color"))
	_preload_particles()
	get_tree().change_scene_to_file.call_deferred(main_scene)

func _preload_particles() -> void:
	for path in preload_paths_particles:
		var particle = load(path).instantiate()
		get_tree().get_root().add_child.call_deferred(particle)
		particle.set_global_position(Vector2(-512, -512))
		particle.set_emitting(true)
		particle.restart()
		particle.queue_free()
	
#func _preload_resourceloader() -> void:
	#ResourceLoader.load
