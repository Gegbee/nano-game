extends Node2D

const SWING_TIME : float = 1.0
var swing_init : bool = false
onready var bothurt = $bothurt
var target_pos : Vector2 = Vector2()

export var damage : int = 0.0
export var knockback_mult : float = 1.0
func _ready():
	$RayCast2D.add_exception(get_parent())
	
func _process(_delta):
	pass
	
	

func attack():
#	print()
	if $Timer.time_left == 0:
#		swing_init = true
		$Timer.start(SWING_TIME/2)
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play('hit')
		if is_instance_valid(Global.player) and Global.player == get_parent():
			get_parent().audio[2].pitch_scale = 1+randf()/4
			get_parent().audio[2].play()
			Global.setCameraShake(0.1)
			
		
		# WHERE THE REAL HIT HAPPENS
#		swing_init = false
		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider.is_in_group('entity'):
				bothurt.pitch_scale = 1.5 + randf()-0.5
				bothurt.play()
				collider.damage(damage, -(collider.global_position - global_position), 100 * knockback_mult)
				if get_parent().is_in_group('player'):
					#jank af but im not paid enough for this
					if get_parent().name[0] == "N":
						get_parent().get_node("playerhurt").play()
					Global.setCameraShake(0.2)
		$Timer.start(SWING_TIME/2)

func aim(pos : Vector2):
	if $Timer.time_left == 0:
		rotation = atan2(pos.y, pos.x)
		
#func _on_Timer_timeout():
#	if swing_init and $Timer.time_left == 0:
#		# WHERE THE REAL HIT HAPPENS
#		swing_init = false
#		$RayCast2D.force_raycast_update()
#		if $RayCast2D.is_colliding():
#			var collider = $RayCast2D.get_collider()
#			if collider.is_in_group('entity'):
#				bothurt.pitch_scale = 1.5 + randf()-0.5
#				bothurt.play()
#				collider.damage(damage, -(collider.global_position - global_position), 100 * knockback_mult)
#				if get_parent().is_in_group('player'):
#					#jank af but im not paid enough for this
#					if get_parent().name[0] == "N":
#						get_parent().get_node("playerhurt").play()
#					Global.setCameraShake(0.2)
#		$Timer.start(SWING_TIME/2)
#	else:
#		pass
##		swing_init = true


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "hit":
		$AnimatedSprite.play('default')
