extends Control

@onready var samples_container: VBoxContainer = %SamplesVContainer
@onready var palette_container: VBoxContainer = %PaletteVContainer

var Preview: Resource = preload("res://src/objects/UI/preview/preview.tscn")

func _ready():
	GlobalSignalbus.SampleAdded.connect(_on_sample_added)
	GlobalSignalbus.ColorAdded.connect(_on_color_added)
	GlobalSignalbus.PreviewSelected.connect(_on_preview_selected)
	#GlobalSignalbus.ToolSelected.connect(tool_select)

func add_preview(t: int, r: Variant, i: int) -> void:
	var node: PreviewBoxSample = Preview.instantiate()
	node.set_type(t)
	node.set_index(i)
	match t:
		0: # Sample preview
			# var preview = Generate sample preview
			%SamplesVContainer.add_child(node)
			node.set_image(null)
			node.set_text(r.get_label())
		1: # Color preview
			'''
			Thats the thing I came up with...
			In theory, I could've made this in a draw method (TODO:, btw) using draw_rect for color
			and draw_texture_rect for audiowave.
			But I already done it this way. 1D gradient is too small and doesnt scale along y-axis,
			so I used a 2D gradient instead. Silly stuff!
			'''
			var g := GradientTexture2D.new()
			var gt := Gradient.new()
			gt.add_point(0., r)
			gt.remove_point(1)
			g.set_gradient(gt)
			%PaletteVContainer.add_child(node)
			node.set_image(g)
			node.set_text("0x" + r.to_html(false).to_upper())
	node.button.pressed.connect(_on_preview_selected.bind(node))

func tool_select(t: int) -> void:
	match t:
		0: #pad_generator
			samples_container.hide()
			palette_container.show()
			#misc_menu.hide()
		1: #spawner_generator
			samples_container.show()
			palette_container.show()
			#misc_menu.hide()
		2: #misc menu
			samples_container.hide()
			palette_container.hide()
			#misc_menu.show()
			
			# toggle ball trajectory
			# toggle ball collisions
			# toggle color as collision layer
			# toggle despawn on no movement
			# toggle particles
			
			# [.0 - 25] minimal ball speed 
			# [.0 - 1.]delay between plays
			
			# volume slider
			
			## tools
			# emit all at once
			# emit all at cd
			# remove balls
			# nuke field
			
		_: #hide_all
			samples_container.hide()
			palette_container.hide()

func _on_sample_added(s: SampleResource, i: int) -> void:
	add_preview(0, s, i)

func _on_color_added(c: Color, i: int) -> void:
	add_preview(1, c, i)

func _on_preview_selected(n: PreviewBoxSample) -> void:
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
			printerr("No type provided on preview_selected signal.")

func _on_button_pressed(t: int) -> void:
	GlobalSignalbus.emit_signal("ToolSelected", t)
	tool_select(t)
