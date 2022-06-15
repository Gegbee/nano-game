extends Node


func _ready():
	$thefire.playing = true
	MusicController.music = [$thefire, $carbenssong, $game, $combat, $nanoshope, $preboss, $eddsong, $eviledd, $moodydeath]
