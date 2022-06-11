extends Node2D

func _input(event):
	if Input.is_action_just_pressed("respawn"):
		if is_instance_valid(Global.player):
			Global.player.queue_free()
		var _player = Global.preloads["player"].instance()
		add_child(_player)
		_player.global_position = Global.respawn_point

func _process(delta):
	# CODE TO CHANGE ENVIRONMENT BASED ON PLAYERS X COORD
	if is_instance_valid(Global.player):
		var player_x = Global.player.global_position.x
		if player_x > $EnvChangers/Pos0.position.x:
			$CanvasLayer/DebugLabel.text = "FPS:" + str(Engine.get_frames_per_second()) + " - blue"
			Global.setEnvColor(Color("06121e"), Color("010c17"))
		elif player_x < $EnvChangers/Pos0.position.x and player_x >= $EnvChangers/Pos1.position.x:
			Global.setEnvColor(Color("220401"), Color("120101"))
			$CanvasLayer/DebugLabel.text = "FPS:" + str(Engine.get_frames_per_second()) + " - red"
		else:
			Global.setEnvColor(Color("230820"), Color("180216"))
			$CanvasLayer/DebugLabel.text = "FPS:" + str(Engine.get_frames_per_second()) + " - purple"
	
