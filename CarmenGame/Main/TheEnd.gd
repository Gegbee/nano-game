extends Control


func _ready():
	$MarginContainer/Label.percent_visible = 0
	$Tween.interpolate_property($MarginContainer/Label, "percent_visible", 0, 1, 8.0, Tween.TRANS_LINEAR)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(12.0), "timeout")
	get_tree().change_scene("res://Menus/MainMenu.tscn")
