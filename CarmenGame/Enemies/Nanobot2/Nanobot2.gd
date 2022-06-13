extends Entity2D


const SPEED : float = 12.0
const HIT_DISTANCE = 32
var hitting : bool = false

var move_vel := Vector2()
var deathpos = Vector2.ZERO

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
			print(c)
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
		if !hitting and Global.enemies_can_hurt:
			$Melee.attack()
			hitting = true
			$Timer.start(1.0)
			
		move_vel = Vector2()
	else:
		state = IDLE
	
	$Melee.aim(player_dir)
	$Sprite.scale.x = -sign(player_dir.x)
	move(move_vel, delta)
	if deathpos != Vector2.ZERO:
		position = deathpos


func _on_Timer_timeout():
	hitting = false
	state = IDLE
