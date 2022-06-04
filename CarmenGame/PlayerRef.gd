extends Node


var player : Entity2D = null

func get_player_distance(global_pos):
	if player:
		return (player.global_position - global_pos).length()
