extends CollisionPolygon2D


export (NodePath) var polygon_copy
func _ready():
	polygon = get_node(polygon_copy).polygon
	global_position = get_node(polygon_copy).global_position
