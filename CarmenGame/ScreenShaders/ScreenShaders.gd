extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.chrabr = $Control/Crt
	$Control.visible = true

func _process(delta):
	var new_amt = move_toward($Control/Crt.material.get_shader_param("aberration"),0.0 , delta * 1.0)
	$Control/Crt.material.set_shader_param("aberration", new_amt)
