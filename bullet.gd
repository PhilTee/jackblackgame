extends Area2D

const SPEED = 250
var collision_class
var direction
var velocity = Vector2()
var fired_by

func _process(delta):
	velocity.x = direction * SPEED * delta
	translate(velocity)

func _on_timer_timeout():
	fired_by.bullet_count -= 1
	queue_free()

func _on_body_entered(body):
	if body.get_class() == "TileMap":
		direction = direction * -1
	if body.has_method("take_damage"):
		body.take_damage(1)
		_on_timer_timeout()

func _on_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	_on_body_entered(area)
