extends Node

@onready var ui: UI = $UI

func _ready():
	ui.set_ball_pool($Pools/BallPool)
	ui.set_emitter_pool($Pools/EmitterPool)
	ui.set_pad_pool($Pools/PadPool)
	
func _process(delta):
	pass
