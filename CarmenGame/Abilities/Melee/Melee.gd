extends Node2D

const SWING_TIME : float = 0.2
var swing_init : bool = false

func _ready():
	$AnimatedSprite.play('hit')
	
func _process(delta):
	if $Timer.time_left == 0:
		var local_mouse_pos = get_global_mouse_position()-global_position
		rotation = atan2(local_mouse_pos.y, local_mouse_pos.x)
	

func attack():
	if $Timer.time_left == 0:
		swing_init = true
		$Timer.start(SWING_TIME/2)
		$AnimatedSprite.play('hit')


func _on_Timer_timeout():
	if swing_init:
		# WHERE THE REAL HIT HAPPENS
		swing_init = false
		$Area2D/CollisionShape2D.disabled = false
		$Timer.start(SWING_TIME/2)
	else:
		swing_init = true
		$Area2D/CollisionShape2D.disabled = true


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "hit":
		$AnimatedSprite.play('default')


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		body.damage(1, (-body.global_position + global_position).normalized(), 60)
