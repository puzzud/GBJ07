extends Entity
class_name Hero

var pushing: bool = false
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
		intendedDirection.y += 1.0
	if Input.is_action_pressed("ui_down"):
		intendedDirection.y -= 1.0
	
	motion = Vector3(0.0, 0.0, 0.0)
	
	if intendedDirection.length() > 0.0:
		direction = intendedDirection
		move(direction)
	
	updateAnimation(delta)

func onCollision(collision: KinematicCollision):
	var timer: Timer = $Timers/PushTimer
	
	var collisionDirection: Vector2 = getBasicDirection(Vector2(collision.normal.x, collision.normal.y) * -1)
	
	if pushee == null:
		if timer.is_stopped():
			print("Staring Push")
			
			pushing = true
			timer.start()
			pushee = collision.collider
			pushDirection = collisionDirection
	else:
		if intendedDirection != collisionDirection:
			print("Not pushing " + str(OS.get_ticks_msec()))
			
			pushing = false
			timer.stop()
			pushee = null
			pushDirection = Vector2.ZERO
		else:
			print("Pushing " + str(OS.get_ticks_msec()))

func onCollisionEnd():
	$Timers/PushTimer.stop()
	pushing = false
	pushee = null
	pushDirection = Vector2.ZERO

func onPushTimerTimeout():
	if pushee != null:
		push(pushee)

func push(pushee: Entity):
	if pushee is Block:
		var block: Block = pushee
		var boardCellCoordinates = block.boardCellCoordinates
		var pushTargetBoardCellCoordinates = boardCellCoordinates + pushDirection
		# TODO: Bound checking.
		
		var board = Global.game.getStage().board
		var boardLevel = board[block.boardLevelIndex]
		var boardCellContents = boardLevel[pushTargetBoardCellCoordinates.y][pushTargetBoardCellCoordinates.x]
		if boardCellContents == null:
			pushee.moveToBoardCoordinates(pushTargetBoardCellCoordinates)
	
	print("Pushed block")
	pushing = false
	pushee = null
	pushDirection = Vector2.ZERO

func getBasicDirection(direction: Vector2) -> Vector2:
	if abs(direction.x) < 0.0001:
		direction.x = 0
	if abs(direction.y) < 0.0001:
		direction.y = 0
	
	return direction

func updateAnimation(delta):
	if motion.length() == 0.0:
		if direction.x != 0.0:
			$AnimationPlayer.play("idle_horizontal")
		elif direction.y > 0.0:
			$AnimationPlayer.play("idle_vertical_up")
		elif direction.y < 0.0:
			$AnimationPlayer.play("idle_vertical_down")
	else:
		if direction.x != 0.0:
			$AnimationPlayer.play("walk_horizontal")
			$Sprite.flip_h = direction.x < 0.0
		else:
			if direction.y != 0.0:
				if direction.y > 0.0:
					$AnimationPlayer.play("walk_vertical_up")
				elif direction.y < 0.0:
					$AnimationPlayer.play("walk_vertical_down")
