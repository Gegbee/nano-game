extends Entity2D

var can_slide : bool = true

const SPEED = 150
const ACCEL = 2000
const JUMP_SPEED = 300

const CAT_MAX_TIME = 0.3
var cat_time : float = 0.0
var can_jump := false
var can_dash : bool = true

var jump_movement_y : float = 0.0
var floor_movement_x : float = 0.0
var slide_movement_x : float = 0.0
var dash_movement_x : float = 0.0

export var melee : NodePath

func _ready():
	$NPCDetection.add_to_group("player_npc_area")
	add_to_group('player')
	
func _physics_process(delta):

	var dir = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_pressed("crouch") and is_on_floor():
		if can_slide:
			if Input.is_action_just_pressed("crouch"):
				slide_movement_x = 300.0 * sign(dir.x)
			slide_movement_x = lerp(slide_movement_x, 0, 2 * delta)
			floor_movement_x = lerp(floor_movement_x, 0, 20 * delta)
		scale.y = 0.7
	elif can_dash and Input.is_action_just_pressed("dash") and !is_on_floor() and abs(vel.x) > 0:
		can_dash = false
		dash_movement_x = sign(vel.x) * 400
		scale.y = 1
		floor_movement_x = lerp(floor_movement_x, 0, 20 * delta)
	else:
		scale.y = 1
		slide_movement_x = 0.0
		if abs(dir.x) > 0:
			if is_on_floor():
				floor_movement_x += delta * ACCEL * dir.x
			else:
				floor_movement_x += delta * ACCEL / 4 * dir.x
		else:
			if is_on_floor():
				floor_movement_x = lerp(floor_movement_x, 0, 30 * delta)
			else:
				floor_movement_x = lerp(floor_movement_x, 0, 1 * delta)
		
		dash_movement_x = lerp(dash_movement_x, 0, 5 * delta)
	
	floor_movement_x = clamp(floor_movement_x, -SPEED, SPEED)
	vel.x = dash_movement_x + slide_movement_x + floor_movement_x
	
	if cat_time >= CAT_MAX_TIME:
		can_jump = false
		
	if is_on_floor():
		can_dash = true
		can_jump = true
		cat_time = 0.0
	else:
		cat_time += delta
	
	vel.y += GRAVITY * delta
				
	if can_jump and Input.is_action_just_pressed("up"):
		vel.y = -JUMP_SPEED
		can_jump = false
	if !can_jump and Input.is_action_just_released("up"):
		vel.y *= 0.7
	
	move(delta)
	
	if vel.x > 0:
		$Sprite.scale.x = -1
	elif vel.x < 0:
		$Sprite.scale.x = 1
		
	if melee != null:
		if Input.is_action_just_pressed("attack_left"):
			get_node(melee).attack()

