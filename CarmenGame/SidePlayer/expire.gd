extends Node2D
var is_fading: bool = false



func _on_Timer_timeout():
	$Timer2.start()
	queue_free()
