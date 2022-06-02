extends Node2D


var num_of_pieces : int = 2
export var piece_length : float = 10 # in pixels
export var piece_width : float = 4
export var color : Color = Color(1, 1, 1, 1)

var polygon1 : Polygon2D = null
var polygon2 : Polygon2D  = null

var max_length = piece_length * num_of_pieces

var target_pos : Vector2 = Vector2()

func _ready():
	max_length = piece_length * num_of_pieces
	polygon1 = Polygon2D.new()
	polygon2 = Polygon2D.new()
	var new_polygon_points = polygon1.polygon
	new_polygon_points.append(Vector2(-piece_width / 2, 0))
	new_polygon_points.append(Vector2(piece_width / 2, 0))
	new_polygon_points.append(Vector2(piece_width / 2, piece_length))
	new_polygon_points.append(Vector2(-piece_width / 2, piece_length))
	# Polygon should have its origin at the center joint rotation point, 
	# with width even on each side and length going downwards.
	polygon1.polygon = new_polygon_points
	polygon1.color = color
	polygon2.polygon = new_polygon_points
	polygon2.color = color
	add_child(polygon1)
	polygon1.add_child(polygon2)
	polygon2.position.y = piece_length
	
	
func _process(delta):
	if target_pos.length() > max_length:
		target_pos = target_pos.normalized() * max_length
		polygon1.position = Vector2()
		polygon1.rotation = atan2(target_pos.y, target_pos.x) - PI/2
		polygon2.rotation = 0.0
	elif target_pos.length() > 0:
		polygon1.position = Vector2()
		polygon1.rotation = atan2(target_pos.y, target_pos.x) - PI/2 + acos(
			(pow(target_pos.length(), 2) + pow(piece_length, 2) - pow(piece_length, 2))
			/ (2 * target_pos.length() * piece_length)
			)
		polygon2.rotation = PI + acos(
			(pow(piece_length, 2) + pow(piece_length, 2) - pow(target_pos.length(), 2))
			/ (2 * piece_length * piece_length)
			)
