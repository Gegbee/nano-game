extends Node2D

func _input(event):
	if Input.is_action_just_pressed("respawn"):
		if is_instance_valid(Global.player):
			Global.player.queue_free()
		print("pressed")
		var _player = Global.preloads["player"].instance()
		add_child(_player)
		_player.global_position = Global.respawn_point

func _ready():
	Global.bg_elements = $QuickMap/BackgroundElements
