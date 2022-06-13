extends Control
	
func _input(_event):
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene("res://Main/Main.tscn")
	elif Input.is_action_just_pressed("escape"):
		get_tree().quit()
