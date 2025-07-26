extends Control
class_name UI

@onready var samples_container: VBoxContainer = %SamplesVContainer
@onready var palette_container: VBoxContainer = %PaletteVContainer
@onready var opacity_timer: Timer = $OpacityTimer

const SamplePreview: Resource = preload("res://src/objects/UI/preview/sample_preview/sample_preview.tscn")
const ColorPreview: Resource = preload("res://src/objects/UI/preview/color_preview/color_preview.tscn")
const opacity_timeout: float = 1.
const opacity_shift_duration: float = 5.

var pad_pool: Pool = null
var ball_pool: Pool = null
var emitter_pool: Pool = null
var tween_opacity: Tween = null

## "Private" methods
func _ready():
	GlobalSignalbus.SampleAdded.connect(_on_sample_added)
	GlobalSignalbus.ColorAdded.connect(_on_color_added)
	#GlobalSignalbus.PreviewSelected.connect(_on_preview_selected)
	%ButtonPad.pressed.connect(_on_tool_button_pressed.bind(0))
	%ButtonEmitter.pressed.connect(_on_tool_button_pressed.bind(1))
	%ButtonNuke.pressed.connect(_on_tool_button_pressed.bind(2))
	
	var samples: Array[SampleResource] = ResourceManager.get_samples()
	var palette: Array[Color] = ResourceManager.get_palette()
	for i in samples.size():
		add_preview(0, samples[i], i)
	for i in palette.size():
		add_preview(1, palette[i], i)
		
	opacity_timer.set_wait_time(opacity_timeout)
	opacity_timer.set_autostart(true)
	opacity_timer.start()

func _process(delta) -> void:
	%MousePos.set_text("Mouse pos: %s" % [str(MouseObserver.get_mouse_pos())])
	%BallAmount.set_text("Balls: %d" % ball_pool.get_amount())
	%PadAmount.set_text("Pads: %d" % pad_pool.get_amount())
	%EmitterAmount.set_text("Emitters: %d" % emitter_pool.get_amount())

func _input(event) -> void:
	if tween_opacity:
		tween_opacity.kill()
		tween_opacity = null
	set_modulate(Color.WHITE)

func _create_opacity_tween() -> void:
	if tween_opacity:
		return
	tween_opacity = create_tween()
	tween_opacity.tween_property(self, "modulate:a", 0.0, opacity_shift_duration)

func _add_sample_preview(t: int, r: SampleResource, i: int) -> void:
	var node = SamplePreview.instantiate()
	node = SamplePreview.instantiate()
	%SamplesVContainer.add_child(node)
	node.set_type(t)
	node.set_index(i)
	node.set_text(r.get_label())
	node.button.pressed.connect(_on_preview_selected.bind(node))

func _add_color_preview(t: int, r: Color, i: int) -> void:
	'''
	Thats the thing I came up with...
	In theory, I could've made this in a draw method (TODO:, btw) using draw_rect for color
	and draw_texture_rect for audiowave.
	But I already done it this way. 1D gradient is too small and doesnt scale along y-axis,
	so I used a 2D gradient instead. Silly stuff!
	'''
	var node = ColorPreview.instantiate()
	node.set_type(t)
	node.set_index(i)
	var g := GradientTexture2D.new()
	var gt := Gradient.new()
	gt.add_point(0., r)
	gt.remove_point(1)
	g.set_gradient(gt)
	%PaletteVContainer.add_child(node)
	node.set_image(g)
	node.set_text("0x" + r.to_html(false).to_upper())
	node.button.pressed.connect(_on_preview_selected.bind(node))

# Signals
func _on_sample_added(s: SampleResource, i: int) -> void:
	add_preview(0, s, i)

func _on_color_added(c: Color, i: int) -> void:
	add_preview(1, c, i)

func _on_preview_selected(n: PreviewBox) -> void:
	match n.get_type():
		0:
			for c in samples_container.get_children():
				c.unselect()
			n.select()
			ResourceManager.set_sample(n.get_i())
		1:
			for c in palette_container.get_children():
				c.unselect()
			n.select()
			ResourceManager.set_color(n.get_i())
		_:
			printerr("Wrong type provided on preview_selected signal.")

func _on_tool_button_pressed(t: int) -> void:
	GlobalSignalbus.emit_signal("ToolSelected", t)
	tool_select(t)

func _on_opacity_timer_timeout():
	_create_opacity_tween()

## Public methods
func add_preview(t: int, r: Variant, i: int) -> void:
	'''
	matching t var is wrong, i know
	'''
	match t:
		0: # Sample preview
			_add_sample_preview(t, r, i)
		1: # Color preview
			_add_color_preview(t, r, i)

func tool_select(t: int) -> void:
	match t:
		0: # pad_generator
			samples_container.hide()
			palette_container.show()
		1: # spawner_generator
			samples_container.show()
			palette_container.show()
		2: # nuke button
			pad_pool.clear()
			ball_pool.clear()
			emitter_pool.clear()
			samples_container.hide()
			palette_container.hide()
		3: # misc menu
			# toggle ball trajectory
			# toggle ball collisions
			# toggle color as collision layer
			# toggle despawn on no movement
			# toggle particles
			
			# [.0 - 25] minimal ball speed 
			# [.0 - 1.]delay between plays
			
			# volume slider
			pass
			
			## tools
			# emit all at once
			# emit all at cd
			
		_: #hide_all
			samples_container.hide()
			palette_container.hide()

func set_ball_pool(p: Pool) -> void:
	ball_pool = p

func set_pad_pool(p: Pool) -> void:
	pad_pool = p

func set_emitter_pool(p: Pool) -> void:
	emitter_pool = p
