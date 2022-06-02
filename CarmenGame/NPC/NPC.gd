extends Area2D

export var _name : String = "No name"
export var sprite_frames : Texture = null

export (Array, String) var lines = ["First line"]

func _ready():
	add_to_group("npc")
#	$AnimatedSprite.frames = SpriteFrames.new()
#	$AnimatedSprite.frames.add_animation("idle")
#	$AnimatedSprite.frames.add_frame("idle", sprite_frames, 0)
#	$AnimatedSprite.frames.add_frame("idle", sprite_frames, 1)
#	$AnimatedSprite.frames.add_frame("idle", sprite_frames, 2)
#	$AnimatedSprite.frames.add_frame("idle", sprite_frames, 3)
#	$AnimatedSprite.play("idle")
	$Sprite.texture = sprite_frames
	$Sprite.vframes = 4
	$Sprite.hframes = 4
	$Sprite.position.y = -$Sprite.texture.get_height() / 8
	var idleAnim = Animation.new()
	idleAnim.add_track(0)
	idleAnim.length = 0.8

	var path = String($Sprite.get_path()) + ":frame"
	idleAnim.track_set_path(0, path)
	idleAnim.track_insert_key(0, 0.0, 0)
	idleAnim.track_insert_key(0, 0.2, 1)
	idleAnim.track_insert_key(0, 0.4, 2)
	idleAnim.track_insert_key(0, 0.6, 3)
	idleAnim.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
	idleAnim.loop = 1

	var aPlayer = AnimationPlayer.new()
	add_child(aPlayer)
	aPlayer.add_animation("idle", idleAnim)
	aPlayer.play("idle")
	$Label.modulate = Color(1, 1, 1, 0)
	$InteractIndicator.modulate = Color(1, 1, 1, 0)
	$Label.text = _name
	$Label.rect_position = Vector2()
	$Label.rect_position.y = -$Sprite.texture.get_height() / 3 - $Label.rect_size.y
	$Label.rect_position.x = -$Label.rect_size.x
	$CollisionShape2D.shape.extents = Vector2(
		$Sprite.texture.get_width()/4/2,
		$Sprite.texture.get_height()/4/2
	)
	$CollisionShape2D.position = Vector2(
		0,
		-$Sprite.texture.get_height()/4/2
	)
	
func _on_NPC_area_entered(area):
	if area.is_in_group('player_npc_area'):
		UiRef.dialog_box.set_dialog = [] + lines
		$InteractIndicator.modulate = Color(1, 1, 1, 1)
		
		
func _on_NPC_area_exited(area):
	if area.is_in_group("player_npc_area"):
		if UiRef.dialog_box.set_dialog == lines:
			UiRef.dialog_box.set_dialog = []
		$InteractIndicator.modulate = Color(1, 1, 1, 0)
