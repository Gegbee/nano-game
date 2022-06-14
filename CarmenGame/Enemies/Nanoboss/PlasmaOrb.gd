extends Area2D

const SPEED = 39.0
var dir : Vector2 = Vector2()

func _ready():
	if is_instance_valid(Global.player):
		dir = (Global.player.global_position - global_position).normalized()
		
func _process(delta):
	if is_instance_valid(Global.player):
		dir.x = move_toward(dir.x, (Global.player.global_position - global_position).normalized().x, delta)
		dir.y = move_toward(dir.y, (Global.player.global_position - global_position).normalized().y, delta * 0.5)
	position += dir * SPEED * delta

func _on_PlasmaOrb_body_entered(body):
	if body.is_in_group('player') and is_instance_valid(Global.player):
		body.damage(1, -(Global.player.global_position - global_position).normalized(), 300)
		queue_free()


func _on_Timer_timeout():
	queue_free()
