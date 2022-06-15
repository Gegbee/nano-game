extends Area2D

var trigger = false
func _ready():
	pass

func _process(delta):
	if trigger:
		Global.camera.limit_top = -128


func _on_cameratrigger_area_entered(area):
	if area.is_in_group('player_npc_area'):
		trigger = true
		get_node("../../AudioStreamPlayer2D").boss = true
