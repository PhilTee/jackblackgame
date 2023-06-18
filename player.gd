extends CharacterBody2D

const bullet = preload("res://bullet.tscn")
const SPEED = 175.0
const JUMP_VELOCITY = -300.0
var bullet_count = 0
var max_bullets = 3
var sprite = Node2D
var hit_points = 5
var health = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _enter_tree():
	sprite = get_node("AnimatedSprite2D")

func die():
	get_tree().reload_current_scene()

func jump():
	velocity.y = JUMP_VELOCITY

func take_damage(damage):
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

	health = health - damage
	if health <= 0:
			die()

func _physics_process(delta):
	# Apply gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	# Handle Shooting
	if Input.is_action_just_pressed("fire"):
		shoot()

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("walk_left", "walk_right")
		
	if direction:
		sprite.flip_h = (direction < 0)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x != 0:
		sprite.animation = "walk"
	else:
		sprite.animation = "idle"

	if sprite.flip_h:
		$ShootSpot.position.x = -27
	else:
		$ShootSpot.position.x = 27

	move_and_slide()

func injury_area_entered(area):
	if area.is_in_group('Enemy'):
		area.reverse_direction()
		take_damage(area.dp)

func stamp_area_entered(area):
	if area.is_in_group("Stampable"):
		jump()
		area.handle_stamp(hit_points)

func shoot():
	if bullet_count >= max_bullets:
		return
		
	var new_bullet = bullet.instantiate()
	get_parent().add_child(new_bullet)
	bullet_count += 1
	new_bullet.position = $ShootSpot.global_position
	new_bullet.direction = (-1 if sprite.flip_h else 1)
	new_bullet.fired_by = self
	
