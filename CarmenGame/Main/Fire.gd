extends Node2D


const DIST = 500
const SCALAR = 0.05
const SHAKE = [.075, -.075]
var up = false
var mod: float = 0

func _process(delta):
	if is_instance_valid(Global.player) and not get_parent().active:
		if abs(position.x - Global.player.position.x) < DIST and abs(position.x - Global.player.position.x) != 0:
			if up:
				mod += (DIST-abs(position.x - Global.player.position.x))/DIST*SCALAR
				if mod >= SHAKE[0]:
					up = false
			else:
				mod -= (DIST-abs(position.x - Global.player.position.x))/DIST*SCALAR
				if mod <= SHAKE[1]:
					up = true
				
			if len(Global.dialog_box.set_dialog) <= 0:
				Global.setChrAbr(mod)
			shake()
		
#        Global.setChrAbr((DIST-abs(position.x - Global.player.position.x))/DIST*SCALAR + mod)

func shake():
	var stillmod = (DIST-abs(position.x - Global.player.position.x))/DIST*0.03
	Global.camera.rotation = stillmod/10 * rand_range(-1, 1)
	Global.camera.offset.x = stillmod*5 * rand_range(-1, 1)
	Global.camera.offset.y = stillmod*5 * rand_range(-1, 1)


func _on_VisibilityNotifier2D_screen_entered():
	show()


func _on_VisibilityNotifier2D_screen_exited():
	hide()
