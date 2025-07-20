class_name CircleNode # the heck is this name
extends Node2D

const outer_circle_radius: float = 45.
const inner_circle_radius: float = 35.
const emitter_circle_radius: float = 5.
#const rot_line_length: float = 80. #outer_circle_radius + 35
const edges_width: float = 2.
const circle_width: float = 3.
const appear_time: float = .25

var active := false
var cursor_rotation: float = .0
var rotation_second_point: Vector2
var opacity: float = .0
var color: Color = Color.BLACK
var fill_color: Color = Color.WHITE
var outline_color: Color = Color.DEEP_PINK
var cd_string: String = "sgjkdf"
var text_position := Vector2.ZERO

var opacity_tween: Tween
var font: Font

func _ready() -> void:
	font = ThemeDB.fallback_font
	text_position.y += outer_circle_radius + 20

func _draw() -> void:
	draw_arc( # Fill arc
		Vector2.ZERO,
		inner_circle_radius + (outer_circle_radius - inner_circle_radius) / 2,
		-PI,
		cursor_rotation,
		25,
		fill_color,
		outer_circle_radius - inner_circle_radius
	)
	draw_circle( # Outer circle
		Vector2.ZERO,
		outer_circle_radius, 
		color,
		false,
		edges_width
	)
	draw_circle( # Inner circle
		Vector2.ZERO,
		inner_circle_radius, 
		color,
		false,
		edges_width
	)
	#draw_circle( # Spawner circle
		#Vector2.ZERO,
		#emitter_circle_radius, 
		#color,
		#false,
		#edges_width
	#)
	draw_line( # Value line
		Vector2.ZERO,
		rotation_second_point, 
		color, 
		1
	)
	#draw_string_outline(
		#font,
		#text_position,
		#cd_string,
		#HORIZONTAL_ALIGNMENT_CENTER,
		#-1,
		#16,
		#3,
		#outline_color
	#)
	#draw_string(
		#font,
		#text_position,
		#cd_string,
		#HORIZONTAL_ALIGNMENT_CENTER,
		#-1,
		#16,
		#color
	#)
	
	
func _process(delta) -> void:
	color.a = opacity
	fill_color.a = opacity
	outline_color.a = opacity
	rotation_second_point = (Vector2.RIGHT * outer_circle_radius).rotated(cursor_rotation)
	queue_redraw()

func _reset() -> void:
	if opacity_tween:
		opacity_tween.kill()
	opacity = 0.
	queue_redraw()

func _appear() -> void:
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "opacity", 1, appear_time)

func _disappear() -> void: # ...disappearance...
	opacity = 1.
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "opacity", 0., appear_time)

func activate() -> void:
	if active:
		return
	active = true
	_reset()
	_appear()

func deactivate() -> void:
	if !active:
		return
	active = false
	_reset()
	_disappear()

func set_cursor_rotation(r: float) -> void:
	cursor_rotation = r

func set_color(c: Color) -> void:
	color = c.darkened(0.25)
	fill_color = c
	outline_color = c.lightened(0.25)

func set_cd(c: float) -> void:
	cd_string = String.num(c, 2)
