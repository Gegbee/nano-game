extends Control
var going = false
#var save = File.new()
var is_empty = true
var diff : int = 1
onready var difficulty_text = $CenterContainer/VBoxContainer/Difficulty
export var filter1: AudioEffectFilter
export var filter2: AudioEffectFilter

var vol = 1.0

func _process(delta):
	if going:
		vol -= 0.3333*delta
	$carbenssong.volume_db = linear2db(vol)-7.866


func _ready():
	if Global.difficulty == 0:
		difficulty_text.text = "\nDifficulty:\n[tab] -> easy"
	elif Global.difficulty == 1:
		difficulty_text.text = "\nDifficulty:\n[tab] -> medium"
	elif Global.difficulty == 2:
		difficulty_text.text = "\nDifficulty:\n[tab] -> hard"
		
	filter1.cutoff_hz = 20500
	filter2.cutoff_hz = 20500
#	save.open("res://save_game.txt", File.READ)
#	var save_text = save.get_as_text()
#	if save_text == "":
#		$CenterContainer/VBoxContainer/clearsave.modulate = Color(0.25, 0.25, 0.25)
#	else:
#		is_empty = false
#		Global.respawn_point = Vector2(save_text.split(",")[0], save_text.split(",")[1])
#
#	save.close()
	
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
#		save.open("res://save_game.txt", File.WRITE)
#		save.store_string(str(Global.respawn_point.x) + "," + str(Global.respawn_point.y))
#		save.close()
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().quit()
#	elif Input.is_action_just_pressed("tab") and not is_empty:
#		save.open("res://save_game.txt", File.WRITE)
#		save.store_string("")
#		save.close()
#		$CenterContainer/VBoxContainer/clearsave.modulate = Color(0.25, 0.25, 0.25)
#		is_empty = true
		
	elif Input.is_action_just_pressed("tab"):
		$difficulty.play()
		diff += 1
		if diff > 2:
			diff = 0

		if diff == 0:
			Global.difficulty = diff + 1
			Global.difficulty_scalar[0] = 0.75
			Global.difficulty_scalar[1] = 0.5
			difficulty_text.text = "\nDifficulty:\n[tab] -> easy"
		elif diff == 1:
			Global.difficulty = diff + 1
			Global.difficulty_scalar[0] = 1.0
			Global.difficulty_scalar[1] = 1.0
			difficulty_text.text = "\nDifficulty:\n[tab] -> medium"
		elif diff == 2:
			Global.difficulty = diff + 1
			Global.difficulty_scalar[0] = 1.5
			Global.difficulty_scalar[1] = 2.0
			difficulty_text.text = "\nDifficulty:\n[tab] -> hard"
