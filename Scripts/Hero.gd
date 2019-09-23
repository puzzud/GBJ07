extends Entity
class_name Hero

var pushee: Entity = null
var pushDirection: Vector2 = Vector2(0, 0)

func _ready():
	$AnimationPlayer.play("idle_horizontal")

func _process(delta):
	intendedDirection = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("ui_left"):
		intendedDirection.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		intendedDirection.x += 1.0
	if Input.is_action_pressed("ui_up"):
		intendedDirection.y -= 1.0
	if Input.is_action_pressed("ui_down"):
		intendedDirection.y += 1.0
	
	motion = Vector2(0.0, 0.0)
	
	if intendedDirection.length() > 0.0:
		direction = intendedDirection
		move(direction)
	
	updateAnimation(delta)

func onCollision(collision: KinematicCollision2D):
	var timer: Timer = $Timers/PushTimer
	if timer.is_stopped():
		timer.start()
		
		pushee = collision.collider
		pushDirection = collision.normal * -1

func onCollisionEnd():
	$Timers/PushTimer.stop()

func onPushTimerTimeout():
	if pushee != null:
		push(pushee)

func push(pushee: Entity):
	pushee.move(pushDirection)
	
	pushee = null

func updateAnimation(delta):
	if motion.length() == 0.0:
		if direction.x != 0.0:
			$AnimationPlayer.play("idle_horizontal")
		elif direction.y < 0.0:
			$AnimationPlayer.play("idle_vertical_up")
		elif direction.y > 0.0:
			$AnimationPlayer.play("idle_vertical_down")
	else:
		if direction.x != 0.0:
			$AnimationPlayer.play("walk_horizontal")
			$Sprite.flip_h = direction.x < 0.0
		else:
			if direction.y != 0.0:
				if direction.y < 0.0:
					$AnimationPlayer.play("walk_vertical_up")
				elif direction.y > 0.0:
					$AnimationPlayer.play("walk_vertical_down")
