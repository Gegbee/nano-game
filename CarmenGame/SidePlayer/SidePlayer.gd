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
# MUST CHANGE WHEN RELEASING GAME
var has_melee : bool = true


export var shield : NodePath
var has_shield : bool = false
var was_on_floor = true 

var cued_NPCs := []

# <audio>
export var filter: AudioEffectFilter
onready var audio = [$Dash, $Slide, $Slice, $Jump, $Step, $Land, $LowHealth, $LowerHealth]

# THIS LINE BELOW NEEDS TO BE GLOBALIZED
onready var enimies = get_node("../Enemies").get_children()

const ENEMY_MUSIC_DIST = 200
#</audio>
func _ready():
	print('player spawned')
	Global.camera = $Camera
	$NPCDetection.add_to_group("player_npc_area")
	add_to_group('player')
	Global.player = self

func _process(delta):
	var closest_dist = 1000.0
	enimies = get_node("../Enemies").get_children()
	for enemy in enimies:
		var temp = position.distance_to(enemy.global_position)
		if temp < closest_dist and temp != 0:
			closest_dist = temp
			
	if closest_dist <= ENEMY_MUSIC_DIST:
		MusicController.combat_ratio = closest_dist/ENEMY_MUSIC_DIST
#		print(MusicController.combat_ratio)
	


func _physics_process(delta):
	
	cued_NPCs.clear()
	for npc in $NPCDetection.get_overlapping_areas():
		cued_NPCs.append(npc)
		
	var dir = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if is_on_floor() and not was_on_floor:
		audio[5].play()
	was_on_floor = is_on_floor()
	
	if Input.is_action_pressed("crouch") and is_on_floor():
		scale.y = 0.8
		knockback_resistance = 4
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
				audio[1].play()
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
		knockback_resistance = 2
		can_dash = false
		dash_movement_x = sign(move_vel.x) * SPEED * 3
		floor_movement_x = lerp(floor_movement_x, 0, 20 * delta)
		audio[0].play()
	else:
		scale.y = 1
		knockback_resistance = 2
		slide_movement_x = 0.0
		if abs(dir.x) > 0:
			if is_on_floor():
				$AnimationPlayer.play('running')
				if not audio[4].playing:
					audio[4].playing = true
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
		audio[3].pitch_scale = randf()/2+1
		audio[3].play()
	if !can_jump and move_vel.y < 0 and Input.is_action_just_released("up"):
		move_vel.y *= 0.5
	
	move(move_vel, delta)
	
	if dir.x > 0:
		$Sprite.scale.x = 1
	elif dir.x < 0:
		$Sprite.scale.x = -1
		
	get_node(melee).target_pos = get_global_mouse_position()-get_node(melee).global_position
	if Input.is_action_just_pressed("attack_left") and has_melee:
		get_node(melee).aim(get_global_mouse_position()-get_node(melee).global_position)
		get_node(melee).attack()
		audio[2].pitch_scale = 1+randf()/4
		audio[2].play()
		Global.setCameraShake(0.1)
			
#	elif Input.is_action_just_pressed("attack_right") and has_shield:
#		get_node(shield).aim(get_global_mouse_position()-get_node(melee).global_position)
#		get_node(shield).attack()
			
func add_melee():
	has_melee = true

func add_shield():
	has_shield = true

func _exit_tree():
	var _player = Global.preloads["player"].instance()
	get_tree().get_root().get_child(len(get_tree().get_root().get_children())-1).add_child(_player)
	_player.global_position = Global.respawn_point
