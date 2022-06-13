extends Label

export var key: String
var flash: bool = false
var timer = 0.0
var counter = 0
var hidden = false
const MAX = 18

func _process(delta):
	if flash:
		timer += delta
		if timer >= 0.05:
			timer = 0
			counter += 1
			if hidden:
				modulate = Color(1, 1, 1, 1)
				hidden = false
			else:
				modulate = Color(1, 1, 1, 0)
				hidden = true
				
			if counter >= MAX:
				flash = false
	
	if Input.is_action_just_pressed(key):
		flash = true
