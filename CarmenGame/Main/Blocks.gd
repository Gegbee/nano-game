extends Node2D

var was_in_bossfight = false
func _process(delta):
	if was_in_bossfight and not Global.in_boss_fight:
		for child in get_children():
			child.lower()
		MusicController.transition_to(5, true)
	was_in_bossfight = Global.in_boss_fight
