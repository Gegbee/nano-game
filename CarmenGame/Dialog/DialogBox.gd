extends CanvasLayer

enum {
	NONE,
	RUNNING,
	IDLE
}
var state : int = IDLE
var set_dialog : Array = []

onready var t = $CenterContainer/Label

func _ready():
	UiRef.dialog_box = self
	t.text = ""
	
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		nextAction()
	if t.percent_visible == 1:
		state = IDLE
		
func runDialog(new_dialog : String):
	state = RUNNING
	
	t.percent_visible = 0
	t.text = new_dialog
	$Tween.interpolate_property(t, "percent_visible", 0, 1, 
	float(len(t.text)) / 20.0, 
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
			t.text = ""
