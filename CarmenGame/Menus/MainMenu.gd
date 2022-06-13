extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	Global.setChrAbr(0.1)
	if Input.is_action_just_pressed("play"):
		get_tree().change_scene("res://Main/Main.tscn")
	elif Input.is_action_just_pressed("exit"):
		get_tree().quit()
