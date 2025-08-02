class_name SpeedPad
extends Pad

func on_ball_collision(b: Ball) -> void:
	b.double_speed()
