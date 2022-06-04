extends AnimatedSprite


func _ready():
	play('anim')
	
	

func _on_AnimatedSprite_animation_finished():
	if animation == 'anim':
		queue_free()
