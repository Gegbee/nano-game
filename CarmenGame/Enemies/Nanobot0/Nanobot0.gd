extends Entity2D

const SPEED : float = 20.0

var facing_dir : int = -1

func _ready():
	$AnimationPlayer.play('idle')
	add_to_group('enemy')
	vel.x = SPEED
	
func _process(delta):
		
	$FloorDetection.force_raycast_update()
	if is_on_floor() and !$FloorDetection.is_colliding():
		vel.x = -1 * sign(vel.x) * SPEED
	$WallDetection.force_raycast_update()
	if $WallDetection.is_colliding():
		vel.x = -1 * sign(vel.x) * SPEED
		
	if vel.x > 0:
		$Sprite.scale.x = -1
		$FloorDetection.position.x = 10
		$WallDetection.cast_to.x = 16
	elif vel.x < 0:
		$Sprite.scale.x = 1
		$FloorDetection.position.x = -10
		$WallDetection.cast_to.x = -16
		
	vel.y += GRAVITY * delta
	move()
	
	if abs(vel.x) > 0:
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
	if body.is_in_group('player'):
		body.damage(1)
