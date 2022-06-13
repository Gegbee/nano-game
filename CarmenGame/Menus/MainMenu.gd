extends Control
var going = false
var save = File.new()
var is_empty = true

func _ready():
	save.open("res://save_game.txt", File.READ)
	var save_text = save.get_as_text()
	if save_text == "":
		$CenterContainer/VBoxContainer/clearsave.modulate = Color(0.25, 0.25, 0.25)
	else:
		is_empty = false
		Global.respawn_point = Vector2(save_text.split(",")[0], save_text.split(",")[1])
	
	save.close()
	
	$AnimationPlayer.play_backwards("fade")
	going = false

func _input(_event):
	if Input.is_action_just_pressed("enter") and not going:
		$CenterContainer/VBoxContainer/Label.flash = true
		going = true
		$AnimationPlayer.play("fade")
		$startgame.play()
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().change_scene("res://Main/Main.tscn")
	elif Input.is_action_just_pressed("escape") and not going:
		$CenterContainer/VBoxContainer/Label2.flash = true
		going = true
		$AnimationPlayer.play("fade")
		$leave.play()
		# see ya next time
		save.open("res://save_game.txt", File.WRITE)
#		save.store_string(str(Global.respawn_point.x) + "," + str(Global.respawn_point.y))
		save.close()
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().quit()
	elif Input.is_action_just_pressed("tab") and not is_empty:
		save.open("res://save_game.txt", File.WRITE)
		save.store_string("")
		save.close()
		$CenterContainer/VBoxContainer/clearsave.modulate = Color(0.25, 0.25, 0.25)
		is_empty = true
		
#	elif Input.is_action_just_pressed("tab"):
#		diff += 1
#		if diff > 2:
#			diff = 0
#
#		if diff == 0:
#			Global.difficulty = 0.75
#			difficulty_text.text = "\nDifficulty:\n<tab> - easy"
#		if diff == 1:
#			Global.difficulty = 1.0
#			difficulty_text.text = "\nDifficulty:\n<tab> - medium"
#		if diff == 2:
#			Global.difficulty = 1.25
#			difficulty_text.text = "\nDifficulty:\n<tab> - hard"
