extends StaticBody2D


export var height : int = 16.0
export var width : int = 32.0

var raised : bool = false

func _ready():
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(width, height)/2)
	$CollisionShape2D.set_shape(shape)
	$CollisionShape2D.position = Vector2(0, -height/2)
	$Sprite/Polygon2D.polygon = [
		Vector2(-width, height)/2, 
		Vector2(width, height)/2, 
		Vector2(width, -height)/2,
		Vector2(-width, -height)/2
	]
	$Sprite/Polygon2D.position = Vector2(0, -height/2)
	$CollisionShape2D.disabled = !raised
	$Sprite.scale.y = 0
	
func rise():
	if !raised:
		$sound.play()
		$CollisionShape2D.set_deferred("disabled", false)
		$Tween.interpolate_property($Sprite, "scale", Vector2(1, 0), Vector2(1, 1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		yield(get_tree().create_timer(0.3), "timeout")
		$hit.play()
		$sound.playing = false
		raised = true
	
func lower():
	if raised:
		$CollisionShape2D.set_deferred("disabled", true)
		$Tween.interpolate_property($Sprite, "scale", Vector2(1, 1), Vector2(1, 0), 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		raised = false
	


func _on_Tween_tween_completed(object, key):
	Global.setCameraShake(0.3)
	Global.setChrAbr(1.0)
