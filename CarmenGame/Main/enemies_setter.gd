extends Node2D


func _ready():
	Global.enemies_container = self
	Global.enimies = []
	for object in get_children():
		Global.enimies.append(weakref(object))
