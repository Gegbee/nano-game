extends AudioStreamPlayer2D

var og = position.x
var tripped = false
var boss = false

func _process(_delta):
	if not boss:
		if not playing:
			playing = true
		if is_instance_valid(Global.player) and Global.player.position.x < position.x and position.x > og-500 and not tripped:
			position.x = Global.player.position.x
		elif position.x < og-500:
			tripped = true
		if tripped:
			position.x += 1
	else:
		if is_instance_valid(Global.player):
			position.x = Global.player.position.x
