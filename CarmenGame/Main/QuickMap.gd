tool
extends Node2D

export(bool) var reset = false setget onReset
export var texture : Texture = null


func onReset(isTriggered):
	if (isTriggered):
		$TileMap.clear()
		var image = texture.get_data()
		image.lock()
		for row in image.get_height():
			for column in image.get_width():
				var color = image.get_pixel(image.get_width() - column - 1, image.get_height() - row - 1)
				if color.to_html(false) == "0068ff":
					$TileMap.set_cell(-column, -row+16, 0)
#				if color.to_html(false) == "ffffff":
#					$TileMap.set_cell(-column, -row+16, 1)
