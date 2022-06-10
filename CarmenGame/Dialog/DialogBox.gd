extends CanvasLayer

enum {
	NONE,
	RUNNING,
	IDLE
}
var state : int = IDLE
var cur_dialog : Array = []
var set_dialog : Array = []

onready var t = $CenterContainer/VBoxContainer/Dialog
onready var n = $CenterContainer/VBoxContainer/Name

func _ready():
	Global.dialog_box = self
	t.text = ""
	n.text = ""
	
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		nextAction()
	if t.percent_visible == 1:
		state = IDLE
		
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
		if len(set_dialog) > 0:
			runDialog(set_dialog[0])
			set_dialog.remove(0)
		else:
			n.text = ""
			t.text = ""
