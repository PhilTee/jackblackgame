extends StaticBody2D

const DISAPPEAR_DELAY = 0.5  # Delay in seconds before the platform disappears
const REAPPEAR_DELAY = 3.0  # Delay in seconds before the platform reappears

var disappearTimer: Timer
var reappearTimer: Timer
var collisionShape: CollisionShape2D

func _ready():
	$Area2D.connect("body_exited", _onPlatformBodyExited)
	$Area2D.connect("body_entered", _onPlatformBodyEntered)
	
	disappearTimer = Timer.new()
	add_child(disappearTimer)
	disappearTimer.set_wait_time(DISAPPEAR_DELAY)
	disappearTimer.set_one_shot(true)
	disappearTimer.connect('timeout', _onTimerTimeout)

	reappearTimer = Timer.new()
	add_child(reappearTimer)
	reappearTimer.set_wait_time(REAPPEAR_DELAY)
	reappearTimer.set_one_shot(true)
	reappearTimer.connect('timeout', _onReappearTimerTimeout)

	collisionShape = $CollisionShape2D

func _onTimerTimeout():
	collisionShape.set_deferred("disabled", true)
	visible = false
	reappearTimer.start()

func _onReappearTimerTimeout():
	reappearTimer.stop()
	visible = true
	collisionShape.set_deferred("disabled", false)

func _onPlatformBodyEntered(body: Node):
	if body.is_in_group("Player"):
		disappearTimer.start()

func _onPlatformBodyExited(body: Node):
	if body.is_in_group("Player"):
		disappearTimer.stop()
