extends Control

var type = false


func _process(delta):
	$loop.playing = true
	if type: 
		$type.playing = true
	
func _ready():
	$start.play()
	$MarginContainer/Label.percent_visible = 0
	yield(get_tree().create_timer(3.0), "timeout")
	$beep.play()
	$MarginContainer/Label.percent_visible = 0.01
	yield(get_tree().create_timer(1.0), "timeout")
	type = true
	$Tween.interpolate_property($MarginContainer/Label, "percent_visible", 0.01, 1, 8.0, Tween.TRANS_LINEAR)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	type = false
	yield(get_tree().create_timer(10.0), "timeout")
	$beep.play()
	$MarginContainer/Label.hide()
	yield(get_tree().create_timer(2.0), "timeout")
#	get_tree().change_scene("res://Menus/MainMenu.tscn")
	get_tree().quit()
