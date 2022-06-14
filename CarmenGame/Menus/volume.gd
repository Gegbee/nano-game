extends HSlider
export var music: bool
var old_val = 0.0

func _ready():
	if music:
		value = db2linear(MusicController.musvol)/db2linear(-6.0)*8
	else:
		value = db2linear(MusicController.sfxvol)*8
		
	old_val = value

func _input(event):
	if event.is_action_released("attack_left") and old_val != value:
		if music:
			MusicController.musvol = linear2db(value*db2linear(-6.0)/8)
		else:
			MusicController.sfxvol = linear2db(value/8)
		old_val = value
		
		$test.play()


func _on_HSlider_value_changed(value):
	if music:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(value*db2linear(-6.0)/8))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music-master"), linear2db(value*db2linear(-6.0)/8))
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), linear2db(value/8))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx-master"), linear2db(value/8))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("nano1"), linear2db(value/8))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("nano2"), linear2db(value/8))
