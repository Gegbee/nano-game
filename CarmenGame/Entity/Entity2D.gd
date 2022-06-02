extends KinematicBody2D

class_name Entity2D

export var health_bar_path : NodePath
var health_bar = null

const GRAVITY : float = 600.0

export var MAX_HEALTH : int = 10.0
export var knockback_resistance : float = 1.0

var health : int = MAX_HEALTH
var impulse_vector : Vector2 = Vector2()
var vel : Vector2 = Vector2()

func _ready():
	health = MAX_HEALTH
	add_to_group('entity')
	health_bar = get_node(health_bar_path)

func _physics_process(delta):
	pass
		
func move(delta = 0.0):
	vel = move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
	
func damage(dmg : int, impulse_dir : Vector2 = Vector2(), impulse_strength : float = 0):
	set_health(health - dmg)
	impulse(impulse_dir, impulse_strength)
	print(self.name + " health: " + str(health) + " / " + str(MAX_HEALTH))

func set_health(new_health : int):
	health = new_health
	if health <= 0:
		health = 0
		kys()
	if health_bar:
		health_bar.updateHealth(health)
	
func kys():
	queue_free()
	
func impulse(dir : Vector2, strength: float):
	impulse_vector = dir * strength / knockback_resistance
