extends Node


func _ready():
	$thefire.playing = true
	MusicController.music = [$thefire, $carbenssong, $game, $combat, $nanoshope, $preboss, $eddsong, $eviledd, $moodydeath]
	MusicController.reset = [$thefire.volume_db, $carbenssong.volume_db, $game.volume_db, $combat.volume_db, $nanoshope.volume_db, $preboss.volume_db, $eddsong.volume_db, $eviledd.volume_db, $moodydeath.volume_db]
