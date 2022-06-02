extends Entity2D

const SPEED : float = 50.0
const GRAVITY : float = 700.0

var player : KinematicBody2D = null
var move_vel : Vector2 = Vector2()

func _ready():
	add_to_group('enemy')

func _process(delta):
	if player:
		var player_dir : int = sign((player.global_position - global_position).normalized().x)
		if is_on_floor() and !$Sprite/FloorDetection.is_colliding():
			player_dir = 0
			
		if player_dir > 0:
			$Sprite.scale.x = -1
		elif player_dir < 0:
			$Sprite.scale.x = 1
			
		if is_on_wall() and get_which_wall_collided() == player_dir:
			move_vel.x = 0
		else:
			if is_on_floor():
				move_vel.x = player_dir * SPEED
			
			
	vel.y += GRAVITY * delta
	move()

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
