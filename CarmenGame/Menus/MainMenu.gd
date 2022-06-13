extends Control
var going = false


func _ready():
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
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().quit()
