extends AnimatedSprite


func _ready():
	frame = 0
	play('default')
	
	

func _on_AnimatedSprite_animation_finished():
	if animation == 'default':
		queue_free()
