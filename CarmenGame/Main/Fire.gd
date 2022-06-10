extends Node2D


const DIST = 500
const SCALAR = 0.3
const SHAKE = [.1, -.1, 0.01]
var up = false
var mod: float = 0

func _process(delta):
	if abs(position.x - Global.player.position.x) < DIST and abs(position.x - Global.player.position.x) != 0:
		if up:
			mod += SHAKE[2]
			if mod >= SHAKE[0]:
				up = false
		else:
			mod -= SHAKE[2]
			if mod <= SHAKE[1]:
				up = true
			
		Global.setChrAbr((DIST-abs(position.x - Global.player.position.x))/DIST*SCALAR + mod)


func _on_VisibilityNotifier2D_screen_entered():
	show()


func _on_VisibilityNotifier2D_screen_exited():
	hide()
