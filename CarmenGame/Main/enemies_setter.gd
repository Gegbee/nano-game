extends Node2D


func _ready():
	Global.enimies = []
	for object in get_children():
		Global.enimies.append(weakref(object))
