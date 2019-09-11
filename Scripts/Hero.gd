extends Node2D

var direction = Vector2(1.0, 0.0)
var intendedDirection = Vector2(0.0, 0.0)

export var speed = 24.0

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
	
	var velocity = Vector2(0.0, 0.0)
	
	if intendedDirection.length() > 0.0:
		direction = intendedDirection
		
		velocity = direction * speed * delta
		position += velocity
	
	if velocity.length() == 0.0:
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
