extends Node2D

export var layer_num: int
export var start: int
export var end: int 
const PARALAX_AMT = 200

var ogx = position.x
var maximum = end-start

func _ready():
	maximum = end-start

func _process(delta):
	if is_instance_valid(Global.player):
		var pos_relative = Global.player.position.x - start
		if pos_relative < 0 and pos_relative > end-start:
			if Global.camera.smoothing_speed < 20:
				Global.camera.smoothing_speed += 0.1
			# (pos_relative/maximum) goes from 0-1
			position.x = -((PARALAX_AMT*(pos_relative/maximum))*layer_num)+ogx
		elif Global.camera.smoothing_speed > 2:
			Global.camera.smoothing_speed -= 0.01
