extends Entity2D


const SPEED : float = 25.0
const HIT_DISTANCE = 32
var hitting : bool = false
var facing_dir : int = -1

var move_vel := Vector2()

enum {
	IDLE,
	MOVING,
	HITTING
}
var state = IDLE

func _ready():
	$AnimationPlayer.play('idle')
	add_to_group('enemy')

func _process(delta):
	var player_dir : Vector2 = Vector2()
	if is_instance_valid(Global.player) and Global.get_player_distance(global_position) < 128:
		player_dir = (Global.player.global_position - global_position)
		$RayCast2D.cast_to = player_dir
		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			var c = $RayCast2D.get_collider()
			if c.is_in_group('player'):
				if player_dir.length() < HIT_DISTANCE:
					state = HITTING
				elif state != HITTING:
					state = MOVING
			else:
				state = IDLE
				
	if state == IDLE:
		move_vel = Vector2()
		$AnimationPlayer.play('idle')
	elif state == MOVING:
		move_vel = player_dir.normalized() * SPEED
		$AnimationPlayer.play('moving')
	elif state == HITTING:
		$AnimationPlayer.play('idle')
		move_vel = player_dir.normalized() * SPEED
		if !hitting and Global.enemies_can_hurt:
			hitting = true
			$Timer.start(0.7)
			
#		move_vel = Vector2()
	else:
		state = IDLE
	if player_dir.x > 0:
		facing_dir = sign(player_dir.x)
	elif player_dir.x < 0:
		facing_dir = sign(player_dir.x)
		
	$Melee.aim(player_dir)
	$Sprite.scale.x = -facing_dir
	move(move_vel, delta)


func _on_Timer_timeout():
	$Melee.attack()
	hitting = false
	state = IDLE
