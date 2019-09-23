extends KinematicBody2D
class_name Entity

var direction = Vector2(1.0, 0.0)
var intendedDirection = Vector2(0.0, 0.0)
var motion = Vector2(0.0, 0.0)

export var speed = 24.0

func _ready():
	updateCollision()

func _physics_process(delta):
	if motion.length() == 0.0:
		return
	
	#move_and_slide(motion.normalized() * speed, Vector2(0.0, 0.0))
	var collides = move_and_collide(motion.normalized() * speed * delta)
	if collides != null:
		print(collides.collider.name)

func updateCollision():
	var y = $Sprite.transform.origin.y
	var levelIndex = int(y / 4 * -1) # TODO: Get 4 from somewhere. Level height in pixels?
	
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, false)
	set_collision_layer_bit(2, false)
	set_collision_layer_bit(levelIndex, true)
	
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(2, false)
	set_collision_mask_bit(levelIndex, true)
