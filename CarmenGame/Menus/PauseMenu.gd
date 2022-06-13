extends Node
var going = false

func _ready():
	going = false
	$AnimationPlayer.play_backwards("toblack")
	get_tree().paused = false
	$CanvasLayer/Control.hide()

func _input(_event):
	if Input.is_action_just_pressed("escape") and not going:
		$AnimationPlayer.play("fade")
		Global.setChrAbr(0)
		if get_tree().paused:
			$menu.play()
		else:
			$resume.play()
		get_tree().paused = not get_tree().paused
		$CanvasLayer/Control.visible = not $CanvasLayer/Control.visible
		
	if get_tree().paused and Input.is_action_just_pressed("enter") and not going:
		going = true
		$menu.play()
		$AnimationPlayer.play("toblack")
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().change_scene("res://Menus/MainMenu.tscn")
		get_tree().paused = false

func _process(delta):
	if get_tree().paused:
		$CanvasLayer/Control/ColorRect.visible = true
	else:
		$CanvasLayer/Control/ColorRect.visible = false
		going = false
