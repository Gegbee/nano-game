extends RigidBody2D

const INTENSITY = 150

func _ready():
	apply_impulse(Vector2(rand_range(-INTENSITY, INTENSITY), rand_range(-INTENSITY, INTENSITY)), 
	Vector2(rand_range(-INTENSITY, INTENSITY), rand_range(-INTENSITY, INTENSITY)))
