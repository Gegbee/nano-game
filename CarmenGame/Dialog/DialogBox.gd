extends CanvasLayer

export var filter: AudioEffectFilter
#export var volume_lower: AudioEffectLimiter
const FILTER_SPEED: float = 1.01
const FILTER_HZ: int = 300
#const AMPLIFY_SPEED: float = 0.1
#const AMPLIFY_HZ: int = -10

enum {
	NONE,
	RUNNING,
	IDLE
}
var state : int = IDLE
var set_dialog : Array = []
var speaker = "BOB"
var low = false
var cinematic_mode: bool = false

var cues
onready var t = $CenterContainer/VBoxContainer/Dialog
onready var n = $CenterContainer/VBoxContainer/Name
var speakers = ["Edd", "Carben", "Carmen", "Nano v1", "Nano", "No name", "Edd, The Nanoboss"]

# sees if player has exited dialog to know if dialog should be replyaed
var exited_dialog : bool = true
var played = [false, false, false]


var spoken_to = []
var disable: bool = false

func _ready():
	$cinematic.show()
	$cinematic1.show()
	$AnimationPlayer.play_backwards("fade")
	Global.dialog_box = self
	t.text = ""
	n.text = ""
	
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if is_instance_valid(Global.player) and len(Global.player.cued_NPCs) > 0 and len(set_dialog) < 1 and exited_dialog:
			start_talk(Global.player.cued_NPCs[0].lines, Global.player.cued_NPCs[0]._name)
		nextAction()
	if t.percent_visible == 1:
		state = IDLE
	
	if low and filter.cutoff_hz > FILTER_HZ:
		filter.cutoff_hz /= FILTER_SPEED
	elif not low and filter.cutoff_hz < 20500:
		filter.cutoff_hz *= FILTER_SPEED
#
#	if low and volume_lower.ceiling_db > AMPLIFY_HZ:
#		volume_lower.ceiling_db -= AMPLIFY_SPEED
#	elif not low and volume_lower.ceiling_db < -4:
#		volume_lower.ceiling_db += AMPLIFY_SPEED
#	print(volume_lower.ceiling_db)
	# using limiter cause ear protection (I got noise blasted bruv im going to lose my hearing from bugs like this someday)
	# EDIT: Fuck I did it again, maybe, you know, we dont need it...
	
func runDialog(new_dialog : String):
	var split_dialog = new_dialog.split(":")
	if split_dialog[0].to_lower() == "melee":
		n.text = "<Melee.exe>"
		get_node("SFX/melee").play()
		if is_instance_valid(Global.player):
			Global.player.add_melee()
	elif split_dialog[0].to_lower() == "shield":
		n.text = "<Shield.exe>"
		if is_instance_valid(Global.player):
			Global.player.add_shield()
	else:
		n.text = split_dialog[0] + ":"
		
	state = RUNNING
	
	t.percent_visible = 0
	t.text = split_dialog[1]
	$Tween.interpolate_property(t, "percent_visible", 0, 1, 
	float(len(t.text)) / 30.0, 
	Tween.TRANS_LINEAR, 
	Tween.EASE_OUT)
	print(split_dialog[0])
	
	
	if speakers.has(split_dialog[0]) and split_dialog[2] != "0":
		cues = get_node(split_dialog[0]).get_children()
		for cue in cues + get_node("Nano").get_children():
			cue.playing = false
		cues[int(split_dialog[2])-1].play()
	
	if speaker == "Carben":
		MusicController.transition_to(1)
		played[0] = true
	
	elif speaker == "Carben":
		MusicController.transition_to(2, true)
	
	elif speaker == "Nano v1":
		MusicController.transition_to(4, true)
		played[1] = true
		
	elif speaker == "Nano v1":
		MusicController.transition_to(5, true)
		played[2] = true
		
	$Tween.start()
	
	
func finishRunningDialog():
	$Tween.reset_all()
	$Tween.remove_all()
	state = IDLE
	t.percent_visible = 1
	
func nextAction():
	if state == RUNNING:
		finishRunningDialog()
	elif state == IDLE:
		low = true
		if len(set_dialog) > 0:
			runDialog(set_dialog[0])
			set_dialog.remove(0)
		else:
			if exited_dialog == false:
				exited_dialog = true
				$AnimationPlayer.play_backwards("RESET")
				if speaker == "Edd, The Nanoboss":
					pass
				Global.player.can_move = true
				cinematic_mode = false
			low = false
			n.text = ""
			t.text = ""
			
func fade(to_black: bool):
	if to_black: $AnimationPlayer.play("fade")
	else: $AnimationPlayer.play_backwards("fade")

func start_talk(lines : Array, _speaker : String):
	if not cinematic_mode:
#		spoken_to.append(Global.player.cued_NPCs)
		$AnimationPlayer.play("RESET")
		if is_instance_valid(Global.player):
			Global.player.can_move = false
		cinematic_mode = true
	speaker = _speaker
	set_dialog = [] + lines
	exited_dialog = false
