extends Area2D


export var left_color : Color
export var right_color : Color

			


func _on_EnvChanger_body_exited(body):
	if body.is_in_group('player'):
		if body.global_position.x - global_position.x < 0:
			Global.setEnvColor(left_color)
		else:
			Global.setEnvColor(right_color)
