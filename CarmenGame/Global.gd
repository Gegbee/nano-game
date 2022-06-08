extends Node

var respawn_point : Vector2 = Vector2()

var camera : Camera2D = null

var dialog_box = null

var player : Entity2D = null

var chrabr : ColorRect = null

var env : ColorRect = null

var bg_elements : TileMap = null

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

func setCameraShake(amt: float):
	camera.add_trauma(amt)

func setEnvColor(color : Color):
	print(color - Color("00f8e8e8"))
	env.get_node('Tween').remove_all()
	env.get_node('Tween').interpolate_property(bg_elements, "modulate", bg_elements.modulate, color - Color(0, 0.1, 0.1, 0), 2.0)
	env.get_node('Tween').interpolate_property(env, "color", env.color, color, 2.0)
	env.get_node('Tween').start()
