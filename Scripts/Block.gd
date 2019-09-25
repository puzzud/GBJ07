extends Entity
class_name Block

export(bool) var fastened = false

var boardLevelIndex = 0
var boardCellCoordinates = Vector2(0, 0)

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

func moveToBoardCoordinates(boardCellCoordinates: Vector2):
	var directionToCell = boardCellCoordinates - self.boardCellCoordinates
	
	if directionToCell.x > 0.0:
		directionToCell.x = 1
	elif directionToCell.x < 0.0:
		directionToCell.x = -1
	
	if directionToCell.y > 0.0:
		directionToCell.y = 1
	elif directionToCell.y < 0.0:
		directionToCell.y = -1
	
	move(directionToCell)
