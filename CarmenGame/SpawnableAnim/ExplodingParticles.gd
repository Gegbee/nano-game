extends Node2D


export var time_before_clear : float = 3.0

export (Array, Texture) var particle_textures = []

var exploded_particle = preload("res://SpawnableAnim/ExplodedParticle.tscn")

func _ready():
	for particle in particle_textures:
		var e = exploded_particle.instance()
		e.get_node("Sprite").texture = particle
		add_child(e)
	$Timer.start(time_before_clear)


func _on_Timer_timeout():
	queue_free()
