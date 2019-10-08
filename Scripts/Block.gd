extends Entity
class_name Block

export(bool) var fastened = false

var boardLevelIndex = 0
var boardCellCoordinates = Vector2(0, 0)

var targetCellCoordinates = Vector2(0, 0)

var moving: bool = false

func _ready():
	updateFromFastened()

func _physics_process(delta: float) -> void:
	if moving:
		checkMovingCondition()

func updateFromFastened():
	var fastenedFrameIndex = 0
	if fastened:
		fastenedFrameIndex = 1
	
	$Sprite.frame = fastenedFrameIndex

func moveToBoardCoordinates(boardCellCoordinates: Vector2):
	if fastened:
		return
	
	targetCellCoordinates = boardCellCoordinates
	
	moving = true
	
	# If a block sits on top of this block,
	# move it too.
	# TODO: Make a function to get an adjacent cell contents.
	var board = Global.game.getStage().board
	var aboveBoardLevelIndex = boardLevelIndex + 1
	if aboveBoardLevelIndex < board.size():
		var boardLevel = board[aboveBoardLevelIndex]
		var boardCellContents = boardLevel[boardCellCoordinates.y][boardCellCoordinates.x]
		if boardCellContents != null:
			boardCellContents.moveToBoardCoordinates(boardCellCoordinates)
	
	# Actual move.
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
	
	updateBoardPosition(self.boardCellCoordinates, boardLevelIndex, targetCellCoordinates, boardLevelIndex)

func checkMovingCondition():
	var targetPosition = getPositionFromCellCoordinateAndLevelIndex(targetCellCoordinates, boardLevelIndex)
	var distanceToCellCoordinate = get_global_transform().origin.distance_to(targetPosition)
	if distanceToCellCoordinate <= 0.01:
		#print("Move completed")
		get_global_transform().origin = targetPosition
		moving = false
		motion = Vector3.ZERO

func updateBoardPosition(oldCellCoordinates: Vector2, oldLevelIndex: int, newCellCoordinates: Vector2, newLevelIndex: int) -> void:
	boardCellCoordinates = newCellCoordinates
	boardLevelIndex = newLevelIndex
	
	# TODO: Probably move this code to Stage.
	var board = Global.game.getStage().board
	board[oldLevelIndex][oldCellCoordinates.y][oldCellCoordinates.x] = null
	board[newLevelIndex][newCellCoordinates.y][newCellCoordinates.x] = self
