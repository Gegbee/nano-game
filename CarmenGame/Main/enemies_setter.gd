extends Node2D


func _ready():
	for object in get_children():
		Global.enimies.append(weakref(object))
