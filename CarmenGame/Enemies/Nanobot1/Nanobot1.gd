extends Entity2D

const SPEED : float = 15.0
const HIT_DISTANCE = 24
var hitting : bool = false
var facing_dir : int = -1

var hit_detection_pos : Vector2 = Vector2()
var floor_detection_pos : Vector2 = Vector2()
var move_vel := Vector2()

func _ready():
	floor_detection_pos = $FloorDetection.position
	hit_detection_pos = $HitDetection.position
	$AnimationPlayer.play('idle')
	add_to_group('enemy')
	
func _process(delta):
	if Global.player and Global.get_player_distance(global_position) < 128:
		var player_dir : int = sign((Global.player.global_position - global_position).normalized().x)
		if is_on_floor() and !$FloorDetection.is_colliding() and player_dir == facing_dir:
			player_dir = 0
			
		if player_dir > 0:
			facing_dir = player_dir
			$FloorDetection.position.x = -floor_detection_pos.x
			$HitDetection.cast_to.x = 10
			$HitDetection.position.x = -hit_detection_pos.x
			$Sprite.scale.x = -1
		elif player_dir < 0:
			$Sprite.scale.x = 1
			facing_dir = player_dir
			$HitDetection.cast_to.x = -10
			$HitDetection.position.x = hit_detection_pos.x
			$FloorDetection.position.x = floor_detection_pos.x
			
		if is_on_wall() and get_which_wall_collided() == player_dir:
			move_vel.x = 0
		else:
			if is_on_floor():
				if abs((Global.player.global_position - global_position).x) > HIT_DISTANCE:
					move_vel.x = player_dir * SPEED
				else:
					if !hitting:
						hitting = true
						$Timer.start(1.0)
					move_vel.x = 0
		
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

func _on_Timer_timeout():
	$HitDetection.force_raycast_update()
	if $HitDetection.is_colliding():
		var body = $HitDetection.get_collider()
		print(body)
		if body.is_in_group('player'):
			body.damage(3, (-body.global_position + global_position).normalized(), 300)
	hitting = false
