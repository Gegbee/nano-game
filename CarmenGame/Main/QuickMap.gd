tool
extends Node


export var texture : Texture = null
export var polygon : NodePath

func _ready():
	for row in texture.get_height():
		for column in texture.get_width():
			var color = texture.get_data().get_pixel(texture.get_width()-column, texture.get_height()-row-16)
			if color == "0068ff":
				print('white')
