extends Node2D

func _ready():
	$AnimatedSprite.play()

func _on_Timer_timeout():
	queue_free()
