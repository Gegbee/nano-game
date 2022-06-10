extends Area2D

export var _name : String = "No name"

export (Array, String) var lines = ["First line"]

var time : float = 0.0

func _ready():
	add_to_group("npc")
	$Label.modulate = Color(1, 1, 1, 0)
	$InteractIndicator.modulate = Color(1, 1, 1, 0)
	$Label.text = _name
	$InteractIndicator.position = $InteractStartPos.position

func _process(delta):
	time += delta
	$InteractIndicator.position.y = cos(time * 2) * 2.0 + $InteractStartPos.position.y - 10
	
func _on_NPC_area_entered(area):
	if area.is_in_group('player_npc_area'):
		Global.dialog_box.cur_dialog = [] + lines
		Global.dialog_box.set_dialog = [] + lines
		Global.dialog_box.speaker = _name 
		$InteractIndicator.modulate = Color(1, 1, 1, 1)
		
		
func _on_NPC_area_exited(area):
	if area.is_in_group("player_npc_area"):
		if Global.dialog_box.set_dialog == lines:
			Global.dialog_box.cur_dialog = []
			Global.dialog_box.set_dialog = []
			Global.dialog_box.speaker = "No name"
		$InteractIndicator.modulate = Color(1, 1, 1, 0)
