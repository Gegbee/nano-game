extends Area2D


func _on_cameratrigger_area_entered(area):
	if area.is_in_group('player_npc_area'):
		get_node("../../AudioStreamPlayer2D").boss = true
