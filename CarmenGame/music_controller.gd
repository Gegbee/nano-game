extends Node


var music: Array
var fading = []
var playing = [0]
var combat_ratio: float = 1.0 
const EASE = 1.7


func _process(delta):
	music[2].volume_db = linear2db(pow(combat_ratio, EASE))
	music[3].volume_db = linear2db(1-pow(combat_ratio, EASE))
	for fade in fading:
		music[fade].volume_db = (music[fade].volume_db-0.01)*1.003
		if music[fade].volume_db <= -75:
			music[fade].playing = false
			music[fade].volume_db = 0
			playing.remove(playing.find(fade))
			fading.remove(fading.find(fade))
			


func transition_to(song: int, fade: bool = false):
	print("playing ", music[song].name)
	if fade:
		fading.append_array(playing)
		
	music[song].playing = true
	playing.append(song)
	if song == 2:
		music[3].playing = true
		playing.append(3)

		

