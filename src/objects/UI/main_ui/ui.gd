extends Control

var Preview: Resource = preload("res://src/objects/UI/preview/preview.tscn")

func _ready():
	GlobalSignalbus.SampleAdded.connect(_on_sample_added)
	GlobalSignalbus.ColorAdded.connect(_on_color_added)

func _on_sample_added(s: SampleResource) -> void:
	add_preview(0, s)

func _on_color_added(c: Color) -> void:
	add_preview(1, c)

func add_preview(t: int, r: Variant) -> void:
	var node: PreviewBoxSample = Preview.instantiate()
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
			so used a 2D gradient with one point here. Silly stuff!
			'''
			var g := GradientTexture2D.new()
			var gt := Gradient.new()
			gt.add_point(0., r)
			gt.remove_point(1)
			g.set_gradient(gt)
			%PaletteVContainer.add_child(node)
			node.set_image(g)
			node.set_text("0x" + r.to_html(false))

func create_preview_node() -> void:
	
	pass
