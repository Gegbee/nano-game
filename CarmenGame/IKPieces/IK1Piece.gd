extends Node2D

export var piece_length : float = 10 # in pixels
export var piece_width : float = 4
export var color : Color = Color(1, 1, 1, 1)

var polygon1 : Polygon2D = null

export var target_pos : Vector2 = Vector2()

func _ready():
	polygon1 = Polygon2D.new()
	var new_polygon_points = polygon1.polygon
	new_polygon_points.append(Vector2(-piece_width / 2, 0))
	new_polygon_points.append(Vector2(piece_width / 2, 0))
	new_polygon_points.append(Vector2(piece_width / 2, piece_length))
	new_polygon_points.append(Vector2(-piece_width / 2, piece_length))
	# Polygon should have its origin at the center joint rotation point, 
	# with width even on each side and length going downwards.
	polygon1.polygon = new_polygon_points
	polygon1.color = color
	add_child(polygon1)

func _process(delta):
	if target_pos.length() > piece_length:
		target_pos = target_pos.normalized() * piece_length
	else:
		var new_polygon_points = polygon1.polygon
		new_polygon_points.set(0, Vector2(-piece_width / 2, 0))
		new_polygon_points.set(1, Vector2(piece_width / 2, 0))
		new_polygon_points.set(2, Vector2(piece_width / 2, target_pos.length()))
		new_polygon_points.set(3, Vector2(-piece_width / 2, target_pos.length()))
		# Polygon should have its origin at the center joint rotation point, 
		# with width even on each side and length going downwards.
		polygon1.polygon = new_polygon_points
	polygon1.rotation = atan2(target_pos.y, target_pos.x) - PI/2
