extends CanvasLayer

export var filter: AudioEffectFilter
const FILTER_SPEED: float = 1.01
const FILTER_HZ: int = 1000

enum {
	NONE,
	RUNNING,
	IDLE
}
var state : int = IDLE
var set_dialog : Array = []
var speaker = "BOB"
var low = false


var cues
onready var t = $CenterContainer/VBoxContainer/Dialog
onready var n = $CenterContainer/VBoxContainer/Name
var speakers = ["Edd", "Carben", "Carmen", "Nano", "No name"]

# sees if player has exited dialog to know if dialog should be replyaed
var exited_dialog : bool = true
var played: bool = false


func _ready():
	Global.dialog_box = self
	t.text = ""
	n.text = ""
	
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if len(Global.player.cued_NPCs) > 0 and len(set_dialog) < 1 and exited_dialog:
			set_dialog = [] + Global.player.cued_NPCs[0].lines
			exited_dialog = false

		nextAction()
	if t.percent_visible == 1:
		state = IDLE
	
	if low and filter.cutoff_hz > FILTER_HZ:
		filter.cutoff_hz /= FILTER_SPEED
	elif not low and filter.cutoff_hz < 20500:
		filter.cutoff_hz *= FILTER_SPEED
	
	
func runDialog(new_dialog : String):
	var split_dialog = new_dialog.split(":")
	if split_dialog[0].to_lower() == "melee":
		n.text = "<Melee.exe>"
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
	
	if not played and split_dialog[0] == "Carben":
		MusicController.transition_to(1)
		played = true
	
	if len(set_dialog) == 2 and split_dialog[0] == "Carben":
		MusicController.transition_to(2, true)
		
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
			low = false
			n.text = ""
			t.text = ""
