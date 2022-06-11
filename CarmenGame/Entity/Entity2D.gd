extends KinematicBody2D

class_name Entity2D

export var damage_particles : NodePath
export var health_bar_path : NodePath
export var damage_audio : NodePath
var health_bar = null

const GRAVITY : float = 500.0

export var MAX_HEALTH : int = 10.0
export var knockback_resistance : float = 1.0

var health : int = MAX_HEALTH
var impulse_vector : Vector2 = Vector2()
var impulse_strength : float = 0.0
var vel : Vector2 = Vector2()
var grav_vel : Vector2 = Vector2()

var timer = 0.0
var lowhel = false

func _ready():
	spawned_color_change()
	health = MAX_HEALTH
	add_to_group('entity')
	health_bar = get_node(health_bar_path)

func _physics_process(delta):
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
	grav_vel.y += GRAVITY * delta
	vel = -impulse_vector + move_vel + grav_vel
	vel = move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
	grav_vel.y = vel.y
	
func damage(dmg : int, impulse_dir : Vector2 = Vector2(), strength : float = 0):
	set_health(health - dmg)
	if name == "SidePlayer":
		if health <= 1:
			self.audio[7].playing = true
			lowhel = true
		else:
			self.audio[7].playing = false
			
		if health <= 3:
			self.audio[6].playing = true
		else:
			self.audio[6].playing = false
		
	
	impulse(impulse_dir.normalized(), strength)
	print(self.name + " health: " + str(health) + " / " + str(MAX_HEALTH))

func set_health(new_health : int):
	if new_health < health:
		damage_color_change()
	elif new_health > health:
		lowhel = false
		healing_color_change()
	health = new_health
	if health <= 0:
		health = 0
		kys()
	if health_bar:
		health_bar.updateHealth(health)
	
func kys():
#	if is_instance_valid($AnimationPlayer):
#		$AnimationPlayer.play("kys")
	queue_free()
	
func impulse(dir : Vector2, strength: float):
	impulse_strength = strength
	impulse_vector = dir * strength / knockback_resistance

func damage_color_change():
	modulate = "f32222"
	yield(get_tree().create_timer(0.3), "timeout")
	modulate = "ffffff"
	
func healing_color_change():
	modulate = "1de845"
	yield(get_tree().create_timer(0.3), "timeout")
	modulate = "ffffff"

func spawned_color_change():
	for i in range(0, 4):
		modulate = "5782ee"
		yield(get_tree().create_timer(0.3), "timeout")
		modulate = "ffffff"
		yield(get_tree().create_timer(0.3), "timeout")
