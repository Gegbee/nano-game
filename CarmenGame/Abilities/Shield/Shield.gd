extends KinematicBody2D


var target_pos : Vector2 = Vector2()
const ACTIVE_TIME : float = 0.5
var knockback_mult : float = 5.0

func _ready():
	add_to_group('shield')

func _process(_delta):
	if $Timer.time_left == 0:
		rotation = atan2(target_pos.y, target_pos.x)
	

func attack():
	if $Timer.time_left == 0:
		$Timer.start(ACTIVE_TIME)
		$CollisionShape2D.disabled = false
		
func aim(pos : Vector2):
	if $Timer.time_left == 0:
		rotation = atan2(pos.y, pos.x)

func _on_Timer_timeout():
	$CollisionShape2D.disabled = true
