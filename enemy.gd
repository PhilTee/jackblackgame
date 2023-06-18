class_name Enemy
extends Area2D

var speed = 0
var direction = Vector2.LEFT
var is_on_ground = false
var hp = 0
var dp = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_body_entered)

func _enter_tree():
	start_movement()

func reverse_direction():
	direction = direction * -1

func handle_stamp(damage_points):
	injure(damage_points)
	
func take_damage(damage_points):
	injure(damage_points)

func injure(damage_points):
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

	hp = hp - damage_points
	if hp <= 0:
		queue_free()

func start_movement():
	get_node("AnimatedSprite2D").animation = "walk"
	set_process(true)

func stop_movement():
	get_node("AnimatedSprite2D").animation = "idle"
	set_process(false)
	
func _process(delta):
	if edge_detected():
		reverse_direction()
		
	var velocity = direction * speed * delta
	
	# Apply gravity.
	if not is_on_ground:
		velocity.x = 0
		velocity.y += 300 * delta
	
	# Move the enemy in direction
	translate(velocity)

func edge_detected():
	var raycast_left = get_node("RayCast2D L").is_colliding()
	var raycast_right = get_node("RayCast2D R").is_colliding()
	
	is_on_ground = raycast_left || raycast_right
	
	if !is_on_ground: return false
	
	return(!raycast_left || !raycast_right)

func _on_body_entered(body: Node):
	print("Enemy collision")
	
	if body.get_class() == "TileMap":
		is_on_ground = true
	
