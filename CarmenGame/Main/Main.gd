extends Node2D

func _input(_event):
	if Input.is_action_just_pressed("respawn"):
		if is_instance_valid(Global.player):
			Global.player.set_health(0)
		
func _process(_delta):
	# CODE TO CHANGE ENVIRONMENT BASED ON PLAYERS X COORD
	if is_instance_valid(Global.player):
		var player_x = Global.player.global_position.x
		if player_x > $EnvChangers/Pos0.position.x:
			$CanvasLayer/DebugLabel.text = "FPS:" + str(Engine.get_frames_per_second()) + " - blue"
			Global.setEnvColor(Color("06121e"), Color("010c17"))
			Global.set_camera_limits($EnvChangers/Pos0.position.x, 48, -10000000, 48)
		elif player_x < $EnvChangers/Pos0.position.x and player_x >= $EnvChangers/Pos1.position.x:
			Global.setEnvColor(Color("220401"), Color("120101"))
			Global.set_camera_limits($EnvChangers/Pos1.position.x, $EnvChangers/Pos0.position.x, -10000000, 48)
			$CanvasLayer/DebugLabel.text = "FPS:" + str(Engine.get_frames_per_second()) + " - red"
		else:
			Global.setEnvColor(Color("230820"), Color("180216"))
			Global.set_camera_limits(-10000000, $EnvChangers/Pos1.position.x, -10000000, 48)
			$CanvasLayer/DebugLabel.text = "FPS:" + str(Engine.get_frames_per_second()) + " - purple"


func _on_BossTrigger_body_exited(body):
	if body.is_in_group('player'):
		if !Global.in_boss_fight:
			Global.in_boss_fight = true
			for wall in $BossFight/Walls.get_children():
				wall.rise()
			$NPCs/Carben.queue_free()
			$BossFight/Nanoboss.show()
			$BossFight/Nanoboss.disabled = false
			$BossFight/CarbenDestroyed.show()

func end_game():
	pass
