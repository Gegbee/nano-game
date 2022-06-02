extends Entity2D

const SPEED : float = 80.0
const HIT_DISTANCE = 26
var hitting : bool = false

var player : KinematicBody2D = null
var facing_dir : int = -1

func _ready():
	$AnimationPlayer.play('idle')
	add_to_group('enemy')
	
func _process(delta):
	if player:
		var player_dir : int = sign((player.global_position - global_position).normalized().x)
		if is_on_floor() and !$FloorDetection.is_colliding() and player_dir == facing_dir:
			player_dir = 0
			
		if player_dir > 0:
			facing_dir = player_dir
			$FloorDetection.position.x = 25
			$HitDetection.cast_to.x = 10
			$HitDetection.position.x = 16
		elif player_dir < 0:
			facing_dir = player_dir
			$HitDetection.cast_to.x = -10
			$HitDetection.position.x = -16
			$FloorDetection.position.x = -25
			
		if is_on_wall() and get_which_wall_collided() == player_dir:
			vel.x = 0
		else:
			if is_on_floor():
				if abs((player.global_position - global_position).x) > HIT_DISTANCE:
					vel.x = player_dir * SPEED
				else:
					if !hitting:
						hitting = true
						$Timer.start(1.0)
					vel.x = 0
		
	vel.y += GRAVITY * delta
	move(delta)
	
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
	
func _on_PlayerDetection_body_entered(body):
	if body.is_in_group('player'):
		player = body


func _on_PlayerDetection_body_exited(body):
	if body.is_in_group('player'):
		player = null

func _on_Timer_timeout():
	$HitDetection.force_raycast_update()
	if $HitDetection.is_colliding():
		var body = $HitDetection.get_collider()
		print(body)
		if body.is_in_group('player'):
			body.damage(1, (-body.global_position + global_position).normalized(), 800)
	hitting = false
