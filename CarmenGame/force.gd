extends RigidBody2D

const INTENSITY = 30

func _ready():
	apply_impulse(Vector2.ZERO, Vector2((randi()%3-1)*INTENSITY, abs((randi()%3-1)*INTENSITY)))
