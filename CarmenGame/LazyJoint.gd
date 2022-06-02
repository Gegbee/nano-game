extends Node

export var rotational_force : bool = false
export var linear_force : bool = true
export (float, 0, 1) var laziness = 0.2

export (NodePath) var moving_parent = null
var prev_parent_vel : Vector2 = Vector2()

var max_impulse : int = 100
func _process(delta):
	var vel = get_node(moving_parent).vel
	var impulse = (vel - prev_parent_vel)
	impulse.x = clamp(impulse.x, -max_impulse, max_impulse)
	impulse.y = clamp(impulse.y, -max_impulse, max_impulse)
	print(impulse)
	for child in get_children():
		if linear_force:
			child.position.x = lerp(child.position.x, -impulse.x * laziness, 0.05)
			child.position.y = lerp(child.position.y, -impulse.y * laziness, 0.05)
		if rotational_force:
			var rotational_impulse = -impulse.length()
			print(child.rotation)
			child.rotation = lerp_angle(child.rotation, -rotational_impulse * laziness * 0.2, 0.2)
		
	prev_parent_vel = vel
