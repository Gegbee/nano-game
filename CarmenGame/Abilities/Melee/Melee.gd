extends Node2D

const SWING_TIME : float = 0.2
var swing_init : bool = false

func _ready():
	$RayCast2D.add_exception(get_parent())
	
func _process(_delta):
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
		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider.is_in_group('entity'):
				collider.damage(1, -(collider.global_position - global_position), 200)
				Global.setCameraShake(0.2)
		$Timer.start(SWING_TIME/2)
	else:
		swing_init = true


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "hit":
		$AnimatedSprite.play('default')
