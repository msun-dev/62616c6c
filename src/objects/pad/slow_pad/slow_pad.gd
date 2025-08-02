class_name SlowPad
extends Pad

func on_ball_collision(b: Ball) -> void:
	b.halve_speed()
