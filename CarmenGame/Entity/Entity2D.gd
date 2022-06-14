extends KinematicBody2D

class_name Entity2D

export var damage_particles : NodePath
export var health_bar_path : NodePath
export var damage_audio : NodePath
var health_bar = null

var GRAVITY : float = 500.0
export var no_grav : bool = false

export var MAX_HEALTH : int = 10.0
export var knockback_resistance : float = 1.0

var health : int = MAX_HEALTH
var impulse_vector : Vector2 = Vector2()
var impulse_strength : float = 0.0
var vel : Vector2 = Vector2()
var grav_vel : Vector2 = Vector2()

var timer = 0.0
var lowhel = false

var low: int = 0
const FILTER_HZ = 1000
const FILTER_SPEED: float = 1.01

var disabled : bool = false

func _ready():
	spawned_color_change()
	add_to_group('entity')
	health_bar = get_node(health_bar_path)
	health = MAX_HEALTH

func _physics_process(delta):
	if health > 3: 
		low = 0
	if is_instance_valid(Global.player) and self == Global.player:
		if low == 1 and self.filter.cutoff_hz > FILTER_HZ:
			self.filter.cutoff_hz /= FILTER_SPEED
		elif low == 2 and self.filter.cutoff_hz > FILTER_HZ/3: 
			self.filter.cutoff_hz /= FILTER_SPEED
		elif low == 0 and self.filter.cutoff_hz < 20500:
			self.filter.cutoff_hz *= FILTER_SPEED
			self.audio[6].playing = false
			self.audio[7].playing = false
			
	timer += delta
	if lowhel and timer >= 0.5:
		timer = 0.0
		Global.setChrAbr(0.5)
		
	impulse_vector.x = lerp(impulse_vector.x, 0, 5.0 * delta)
	impulse_vector.y = 0.0
	if impulse_vector.length() < 0.2:
		impulse_vector = Vector2()
		impulse_strength = 0.0
		
func move(move_vel : Vector2, delta : float):
	if !no_grav:
		grav_vel.y += GRAVITY * delta
	vel = -impulse_vector + move_vel + grav_vel
	vel = move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
	if !no_grav:
		grav_vel.y = vel.y
	
func damage(dmg : int, impulse_dir : Vector2 = Vector2(), strength : float = 0):
	set_health(health - dmg)
	if is_instance_valid(Global.player) and self == Global.player:
		if health <= 3:
			self.audio[6].playing = true
			low = 1
		else:
			self.audio[6].playing = false
			
		if health <= 1:
			self.audio[7].playing = true
			lowhel = true
			low = 2
		else:
			self.audio[7].playing = false
			
		
	
	impulse(impulse_dir.normalized(), strength)
	print(self.name + " health: " + str(health) + " / " + str(MAX_HEALTH))

func set_health(new_health : int):
	if new_health < health:
		damage_color_change()
	elif new_health > health:
		lowhel = false
		healing_color_change()
	if new_health <= 0 and health > 0:
		kys()
	health = new_health
	if health_bar:
		health_bar.updateHealth(health)
	
func kys():
	if is_in_group('player'):
		Global.player = null
		var particles = Global.preloads["exploding_particles"].instance()
		particles.time_before_clear = 3.0
		particles.particle_textures = [
			load("res://Sideplayer/destroyed_part1.png"),
			load("res://Sideplayer/destroyed_part2.png"),
			load("res://Sideplayer/destroyed_part3.png"),
			load("res://Sideplayer/destroyed_part4.png"),
			load("res://Sideplayer/destroyed_part5.png")
		]
		get_tree().get_current_scene().call_deferred("add_child", particles)
		particles.global_position = self.global_position + Vector2(0, -8)
		disabled = true
		hide()
		yield(get_tree().create_timer(2.0), "timeout")
		Global.dialog_box.fade(true)
		yield(get_tree().create_timer(2.0), "timeout")
		Global.dialog_box.fade(false)
		set_process(true)
		queue_free()
		var _player = Global.preloads["player"].instance()
		var _enemies = Global.preloads["enemies"].instance()
		Global.enemies_container.queue_free()
		Global.enemies_container = null
		get_tree().get_current_scene().call_deferred("add_child", _player)
		get_tree().get_current_scene().call_deferred("add_child", _enemies)
		
		_player.global_position = Global.respawn_point
	else: 
		if is_in_group("boss"):
			Global.dialog_box.start_talk(["Edd, The Nanoboss: Aauhh f*** I'm dying!:3"], "Edd, The Nanoboss")
			Global.dialog_box.nextAction()
			var particles = Global.preloads["exploding_particles"].instance()
			particles.time_before_clear = 20.0
			particles.particle_textures = [
				load("res://Enemies/bosspart1.png"),
				load("res://Enemies/bosspart1.png"),
				load("res://Enemies/bosspart1.png"),
				load("res://Enemies/bosspart2.png"),
				load("res://Enemies/bosspart2.png"),
				load("res://Enemies/bosspart3.png"),
				load("res://Enemies/bosspart3.png")
			]
			get_tree().get_current_scene().call_deferred("add_child", particles)
			particles.global_position = self.global_position + Vector2(0, -8)
			queue_free()
		else:
			var particles = Global.preloads["exploding_particles"].instance()
			particles.time_before_clear = 3.0
			particles.particle_textures = [
				load("res://Enemies/botpart1.png"),
				load("res://Enemies/botpart2.png"),
				load("res://Enemies/botpart3.png")
			]
			get_tree().get_current_scene().call_deferred("add_child", particles)
			particles.global_position = self.global_position + Vector2(0, -8)
			queue_free()
	
func impulse(dir : Vector2, strength: float):
	impulse_strength = strength
	impulse_vector = dir * strength / knockback_resistance

func damage_color_change():
	modulate = "f32222"
	yield(get_tree().create_timer(0.3), "timeout")
	if is_instance_valid(self):
		modulate = "ffffff"
	
func healing_color_change():
	modulate = "1de845"
	yield(get_tree().create_timer(0.3), "timeout")
	if is_instance_valid(self):
		modulate = "ffffff"

func spawned_color_change():
	for i in range(0, 4):
		if is_instance_valid(self):
			modulate = "5782ee"
			yield(get_tree().create_timer(0.3), "timeout")
		if is_instance_valid(self):
			modulate = "ffffff"
			yield(get_tree().create_timer(0.3), "timeout")

