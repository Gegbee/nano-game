extends Node


func _ready():
	get_tree().paused = false
	$CanvasLayer/Control.hide()

func _input(_event):
	if Input.is_action_just_pressed("escape"):
		Global.setChrAbr(0)
		get_tree().paused = not get_tree().paused
		$CanvasLayer/Control.visible = not $CanvasLayer/Control.visible
		
	if get_tree().paused and Input.is_action_just_pressed("enter"):
		get_tree().change_scene("res://Menus/MainMenu.tscn")
		get_tree().paused = false

func _process(delta):
	if get_tree().paused:
		$CanvasLayer/Control/ColorRect.visible = true
	else:
		$CanvasLayer/Control/ColorRect.visible = false
