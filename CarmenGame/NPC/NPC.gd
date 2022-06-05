extends Area2D

export var _name : String = "No name"

export (Array, String) var lines = ["First line"]

func _ready():
	add_to_group("npc")
	$Label.modulate = Color(1, 1, 1, 0)
	$InteractIndicator.modulate = Color(1, 1, 1, 0)
	$Label.text = _name
	
func _on_NPC_area_entered(area):
	if area.is_in_group('player_npc_area'):
		Global.dialog_box.set_dialog = [] + lines
		$InteractIndicator.modulate = Color(1, 1, 1, 1)
		
		
func _on_NPC_area_exited(area):
	if area.is_in_group("player_npc_area"):
		if Global.dialog_box.set_dialog == lines:
			Global.dialog_box.set_dialog = []
		$InteractIndicator.modulate = Color(1, 1, 1, 0)
