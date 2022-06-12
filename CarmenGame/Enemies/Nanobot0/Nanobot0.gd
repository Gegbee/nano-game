extends Entity2D

const SPEED : float = 20.0

var facing_dir : int = -1

var move_vel := Vector2()

func _ready():
	$ambient.pitch_scale += randf()/10-0.05
	$AnimationPlayer.play('idle')
	add_to_group('enemy')
	move_vel.x = SPEED
	
func _process(delta):
		
	$FloorDetection.force_raycast_update()
	if is_on_floor() and !$FloorDetection.is_colliding():
		move_vel.x = -1 * sign(move_vel.x) * SPEED
	$WallDetection.force_raycast_update()
	if $WallDetection.is_colliding():
		move_vel.x = -1 * sign(move_vel.x) * SPEED
		
	if move_vel.x > 0:
		$Sprite.scale.x = -1
		$FloorDetection.position.x = 10
		$WallDetection.cast_to.x = 16
	elif move_vel.x < 0:
		$Sprite.scale.x = 1
		$FloorDetection.position.x = -10
		$WallDetection.cast_to.x = -16

	move(move_vel, delta)
	
	if abs(move_vel.x) > 0:
		$AnimationPlayer.play('walking')
	else:
		$AnimationPlayer.play('idle')

func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return 1
		elif collision.normal.x < 0:
			return -1
	return 0
	


func _on_HitDetection_body_entered(body):
	if body.is_in_group('player') and Global.enemies_can_hurt:
		$playerhurt.play()
		body.damage(1, -body.global_position + global_position, 400)
		Global.setCameraShake(0.2)
		Global.setChrAbr(Global.getChrAbr() + 0.5)
