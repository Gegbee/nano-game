extends Node

var respawn_point : Vector2 = Vector2()

var camera : Camera2D = null

var dialog_box = null

var player : Entity2D = null

var chrabr : ColorRect = null

var enemies_can_hurt: bool = true

var env = null

var enimies = []


var preloads = {
	"jump_anim" : preload("res://SpawnableAnim/JumpAnim.tscn"),
	"slide_anim" : preload("res://SpawnableAnim/SlideAnim.tscn"),
	"ground_anim" : preload("res://SpawnableAnim/GroundAnim.tscn"),
	"dash_anim" : preload("res://SpawnableAnim/DashAnim.tscn"),
	"player" : preload("res://SidePlayer/SidePlayer.tscn")
}
func get_player_distance(global_pos):
	if player:
		return (player.global_position - global_pos).length()

func set_camera_limits(left, right, top, bottom):
	if camera:
		pass

		
func setChrAbr(amt : float):
	chrabr.material.set_shader_param("aberration", amt)

func getChrAbr() -> float:
	return chrabr.material.get_shader_param("aberration")
	
func setCameraShake(amt: float):
	camera.add_trauma(amt)

func setEnvColor(color : Color, offset_color : Color):
	if !env.get_node('Tween').is_active():
#	env.get_node('Tween').remove_all()
		env.get_node('Tween').interpolate_property(env.get_node('Elements'), "modulate", env.get_node('Elements').modulate, offset_color, 2.0)
		env.get_node('Tween').interpolate_property(env.get_node('CanvasLayer/ColorRect'), "color", env.get_node('CanvasLayer/ColorRect').color, color, 2.0)
		env.get_node('Tween').start()
