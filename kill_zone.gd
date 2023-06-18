extends CollisionShape2D


func _on_kill_zone_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
