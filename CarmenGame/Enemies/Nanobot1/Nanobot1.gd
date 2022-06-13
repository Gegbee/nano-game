extends Entity2D

const SPEED : float = 15.0
const HIT_DISTANCE = 38
var hitting : bool = false
var facing_dir : int = -1

var floor_detection_pos : Vector2 = Vector2()
var move_vel := Vector2()
var deathpos = Vector2.ZERO

enum {
	IDLE,
	MOVING,
	HITTING
}
var state = IDLE

func _ready():
	$ambient.pitch_scale += randf()/10.0-0.05-0.75
	floor_detection_pos = $FloorDetection.position
	$AnimationPlayer.play('idle')
	add_to_group('enemy')
	
func _process(delta):
	var player_dir : int = 0
	if is_instance_valid(Global.player) and Global.get_player_distance(global_position) < 128:
		player_dir = sign((Global.player.global_position - global_position).normalized().x)
		if is_on_floor() and !$FloorDetection.is_colliding() and player_dir == facing_dir:
			player_dir = 0
		
		if player_dir > 0:
			facing_dir = player_dir
			$FloorDetection.position.x = -floor_detection_pos.x
		elif player_dir < 0:
			facing_dir = player_dir
			$FloorDetection.position.x = floor_detection_pos.x
		
		if is_on_wall() and get_which_wall_collided() == player_dir:
			state = IDLE
		else:
			if is_on_floor():
				if abs((Global.player.global_position - global_position).x) > HIT_DISTANCE and state != HITTING:
					state = MOVING
				else:
					state = HITTING
	
	else:
		move_vel = Vector2()
	move(move_vel, delta)
	
	if abs(move_vel.x) > 0:
		$AnimationPlayer.play('walking')
	else:
		$AnimationPlayer.play('idle')
	$Sprite.scale.x = -facing_dir
			
	if state == IDLE:
		move_vel = Vector2()
	elif state == MOVING:
		move_vel.x = player_dir * SPEED
	elif state == HITTING:
		if !hitting and Global.enemies_can_hurt:
			hitting = true
			$Timer.start(1.0)
		move_vel.x = 0
	else:
		state = IDLE
	$Melee.aim(Vector2(-$Sprite.scale.x * HIT_DISTANCE, 0))
	if deathpos != Vector2.ZERO:
		position = deathpos
	
func get_which_wall_collided():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.normal.x > 0:
			return 1
		elif collision.normal.x < 0:
			return -1
	return 0

func _on_Timer_timeout():
	$Melee.attack()
#	$HitDetection.force_raycast_update()
#	if $HitDetection.is_colliding():
#		var body = $HitDetection.get_collider()
#		if body.is_in_group('player'):
#			body.damage(3, (-body.global_position + global_position).normalized(), 300)
	hitting = false
	state = IDLE
