extends Entity2D


var init_lines := [
	"Nano: HEE HEE HEE HAH:2", 
	"Edd, The Nanoboss: LETS FIGHT!:3"
]

var end_lines := [
	"Edd, The Nanoboss: Aauhh f*** I'm dying!:3", 
	"Edd, The Nanoboss: Have fun in the next similuation you dumbass!:2"
]

var facing_dir : int = 0
var gone_through_dialogue : bool = false
var plasma_orbs_released : int = 3
var plasma_orb = preload("res://Enemies/Nanoboss/PlasmaOrb.tscn")

enum {
	WALKING,
	PLASMING,
	SLASHING,
	IDLE
}

enum {
	SLASH, 
	ORBS,
	RECHARGE
}
var cur_attack : int = SLASH
var state : int = IDLE
var move_vel := Vector2()
const SPEED = 20.0
var attacking : bool = false

func _ready():
	Global.boss = self
	disabled = true
	hide()
	$AnimatedSprite.play('default')
	$AnimationPlayer.play('idle')
	add_to_group('enemy')
	add_to_group('boss')

func _on_Area2D_body_entered(body):
	if body.is_in_group('player') and !gone_through_dialogue and !disabled:
		init_dialogue()

func init_dialogue():
	Global.dialog_box.start_talk(init_lines, "Edd, The Nanoboss")
	Global.dialog_box.nextAction()
	
func _process(delta):
	if disabled:
		return
	var player_dir : int = 0
	if is_instance_valid(Global.player) and Global.get_player_distance(global_position) < 200:
		player_dir = sign((Global.player.global_position - global_position).normalized().x)
		if gone_through_dialogue:
			if cur_attack == ORBS:
				state = PLASMING
			elif cur_attack == SLASH:
				if Global.get_player_distance(global_position) < 36:
					state = SLASHING
				else:
					state = WALKING
			elif cur_attack == RECHARGE:
				if !attacking:
					attacking = true
					$Timer.start(4.0)
				state == IDLE
		else:
			state = IDLE
			
	if player_dir > 0:
		facing_dir = player_dir
		
	elif player_dir < 0:
		facing_dir = player_dir
	
	$RayCast2D.cast_to.x = facing_dir * 50
	$Sprite.scale.x = facing_dir
	$AnimatedSprite.scale.x = facing_dir * 2
	$AnimatedSprite.position.x = facing_dir * 12
	
	if state == IDLE:
		move_vel = Vector2()
		$AnimationPlayer.play('idle')
	elif state == WALKING:
		move_vel.x = player_dir * SPEED
		$AnimationPlayer.play('walking')
	elif state == SLASHING:
		$AnimationPlayer.play('idle')
		move_vel = Vector2()
		if !attacking:
			attacking = true
			big_slash()
	elif state == PLASMING:
		$AnimationPlayer.play('idle')
		move_vel = Vector2()
		if !attacking:
			attacking = true
			plasma_orbs()
	else:
		state = IDLE
	
	move(move_vel, delta)
	
func big_slash():
	yield(get_tree().create_timer(1.25), "timeout")
	$AnimatedSprite.play('hit')
	yield(get_tree().create_timer(0.25), "timeout")
	$RayCast2D.enabled = true
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		print(collider)
		if collider.is_in_group('player'):
			collider.damage(2 + Global.diffilcuty - 1, -(collider.global_position - global_position), 500)
				#jank af but im not paid enough for this, Greg: lmao L bozo
			if get_parent().name[0] == "N":
				get_parent().get_node("playerhurt").play()
			Global.setCameraShake(0.2)
	$RayCast2D.enabled = false
	cur_attack = ORBS
	attacking = false
	state = IDLE
	
func plasma_orbs():
	for i in plasma_orbs_released:
		var orb = plasma_orb.instance()
		get_tree().get_current_scene().add_child(orb)
		orb.global_position = global_position + Vector2(0, -8)
		yield(get_tree().create_timer(0.8), "timeout")
	cur_attack = RECHARGE
	attacking = false
	state = IDLE


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "hit":
		$AnimatedSprite.play('default')


func _on_Timer_timeout():
	cur_attack = SLASH
	attacking = false
	state = IDLE
