extends Entity2D

var can_slide : bool = true

const SPEED = 72
const ACCEL = 2000
const JUMP_SPEED = 190

const CAT_MAX_TIME = 0.2
var cat_time : float = 0.0
var can_jump := false
var can_dash : bool = true

var jump_movement_y : float = 0.0
var floor_movement_x : float = 0.0
var slide_movement_x : float = 0.0
var dash_movement_x : float = 0.0
var move_vel := Vector2()

export var melee : NodePath
var has_melee : bool = false


export var shield : NodePath
var has_shield : bool = false 

func _ready():
	print('player spawned')
	Global.camera = $Camera
	$NPCDetection.add_to_group("player_npc_area")
	add_to_group('player')
	Global.player = self
	
func _physics_process(delta):
	var dir = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_pressed("crouch") and is_on_floor():
		scale.y = 0.8
		$AnimationPlayer.play('slide')
		if can_slide:
			if Input.is_action_just_pressed("crouch"):
				Global.setChrAbr(0.4)
				Global.setCameraShake(0.1)
				var spawnable_anim = Global.preloads["slide_anim"].instance()
				get_tree().get_root().add_child(spawnable_anim)
				spawnable_anim.global_position = self.global_position+Vector2(0, -8)
				spawnable_anim.scale.x = sign(dir.x)
				slide_movement_x = SPEED * sign(dir.x) * 2.2
			slide_movement_x = lerp(slide_movement_x, 0, 2 * delta)
			floor_movement_x = lerp(floor_movement_x, 0, 20 * delta)
	elif can_dash and Input.is_action_just_pressed("dash") and !is_on_floor() and abs(move_vel.x) > 0:
		Global.setChrAbr(0.9)
		Global.setCameraShake(0.15)
		var spawnable_anim = Global.preloads["dash_anim"].instance()
		get_tree().get_root().add_child(spawnable_anim)
		spawnable_anim.global_position = self.global_position+Vector2(0, -8)
		spawnable_anim.scale.x = -sign(move_vel.x)
		scale.y = 1
		can_dash = false
		dash_movement_x = sign(move_vel.x) * SPEED * 3
		floor_movement_x = lerp(floor_movement_x, 0, 20 * delta)
	else:
		scale.y = 1
		slide_movement_x = 0.0
		if abs(dir.x) > 0:
			if is_on_floor():
				$AnimationPlayer.play('running')
				floor_movement_x += delta * ACCEL * dir.x
			else:
				$AnimationPlayer.play("air")
				floor_movement_x += delta * ACCEL / 6 * dir.x
		else:
			if is_on_floor():
				$AnimationPlayer.play('idle')
				floor_movement_x = lerp(floor_movement_x, 0, 30 * delta)
			else:
				$AnimationPlayer.play("air")
				floor_movement_x = lerp(floor_movement_x, 0, 1 * delta)
		
		dash_movement_x = lerp(dash_movement_x, 0, 5 * delta)
	
	floor_movement_x = clamp(floor_movement_x, -SPEED, SPEED)
	move_vel.x = dash_movement_x + slide_movement_x + floor_movement_x
	
	if cat_time >= CAT_MAX_TIME:
		can_jump = false
		
	if is_on_floor():
		if can_jump == false:
			var spawnable_anim = Global.preloads["ground_anim"].instance()
			get_tree().get_root().add_child(spawnable_anim)
			spawnable_anim.global_position = self.global_position+Vector2(0, -8)
		can_dash = true
		can_jump = true
		cat_time = 0.0
	else:
		cat_time += delta
	
	move_vel.y = 0
	if can_jump and Input.is_action_just_pressed("up"):
		var spawnable_anim = Global.preloads["jump_anim"].instance()
		get_tree().get_root().add_child(spawnable_anim)
		spawnable_anim.global_position = self.global_position+Vector2(0, -8)
		move_vel.y = -JUMP_SPEED
		can_jump = false
	if !can_jump and move_vel.y < 0 and Input.is_action_just_released("up"):
		move_vel.y *= 0.5
	
	move(move_vel, delta)
	
	if dir.x > 0:
		$Sprite.scale.x = 1
	elif dir.x < 0:
		$Sprite.scale.x = -1
		
	if melee != null and has_melee:
		if Input.is_action_just_pressed("attack_left"):
			get_node(melee).attack()
			Global.setCameraShake(0.1)

func add_melee():
	has_melee = true

	

func add_shield():
	has_shield = true
