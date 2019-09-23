extends Entity
class_name Block

export(bool) var fastened = false

func _ready():
	updateFromFastened()

func updateFromFastened():
	var fastenedFrameIndex = 0
	if fastened:
		fastenedFrameIndex = 1
	
	$Sprite.frame = fastenedFrameIndex

func move(direction):
	if fastened:
		return
	
	.move(direction)
