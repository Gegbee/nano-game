extends Control


func _ready():
	$Tween.interpolate_property($CenterContainer/Label, "percent_visible", 0, 1, 4.0, Tween.TRANS_LINEAR)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	yield(get_tree().create_timer(4.0), "timeout")
	get_tree().change_scene("res://Menus/MainMenu.tscn")
