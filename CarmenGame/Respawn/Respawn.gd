extends Area2D




func _on_Respawn_body_entered(body):
	if body.is_in_group('player'):
		Global.respawn_point = self.global_position
		$AnimatedSprite.play('default')
