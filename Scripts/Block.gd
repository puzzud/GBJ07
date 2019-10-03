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

func move(direction: Vector3):
	if fastened:
		return
	
	# If a block sits on top of this block,
	# move it too.
	var board = Global.game.getStage().board
	var aboveBoardLevelIndex = boardLevelIndex + 1
	if aboveBoardLevelIndex < board.size():
		var boardLevel = board[aboveBoardLevelIndex]
		var boardCellContents = boardLevel[boardCellCoordinates.y][boardCellCoordinates.x]
		if boardCellContents != null:
			boardCellContents.move(direction)
	
	.move(direction)

func moveToBoardCoordinates(boardCellCoordinates: Vector2):
	var directionToCell = Vector3(boardCellCoordinates.x, boardCellCoordinates.y, 0)
	directionToCell -= Vector3(self.boardCellCoordinates.x, self.boardCellCoordinates.y, 0)
	
	if directionToCell.x > 0.0:
		directionToCell.x = 1
	elif directionToCell.x < 0.0:
		directionToCell.x = -1
	
	if directionToCell.y > 0.0:
		directionToCell.y = 1
	elif directionToCell.y < 0.0:
		directionToCell.y = -1
	
	move(directionToCell)
