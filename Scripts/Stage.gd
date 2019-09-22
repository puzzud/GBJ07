extends Node2D
class_name Stage

const cellWidth = 16
const cellHeight = 8

export(int) var boardWidth = 10
export(int) var boardHeight = 15

var board = Array()

func _ready():
	board = buildBoard()
	#printBoard(board)

func buildBoard() -> Array:
	var board = Array()
	
	var levelIndex = -1
	for level in $Contents.get_children():
		levelIndex += 1
		var boardLevel = initializeBoardLevel()
		
		for entity in level.get_children():
			if entity is Block:
				if !insertEntityIntoBoardLevel(boardLevel, levelIndex, entity):
					printerr("Failed to insert \"" + entity.name + "\" into level #" + str(boardLevel) + ".")
		
		board.push_back(boardLevel)
		
	return board

func getCellCoordinatesFromBlock(block) -> Vector2:
	var coordinates = Vector2()
	
	coordinates.x = int(block.position.x / cellWidth)
	# TODO: +8 should come from block, as its offset.
	coordinates.y = int((block.position.y + 8) / cellHeight)
	
	return coordinates

func initializeBoardLevel():
	var boardLevel = Array()
	
# warning-ignore:unused_variable
	for y in range(0, boardHeight):
		var boardLevelRow = Array()
		
# warning-ignore:unused_variable
		for y in range(0, boardWidth):
			boardLevelRow.push_back(null)
		
		boardLevel.push_back(boardLevelRow)
	
	return boardLevel

func insertEntityIntoBoardLevel(boardLevel: Array, levelIndex: int, entity) -> bool:
	var cellCoordinates = getCellCoordinatesFromBlock(entity)
	var x = cellCoordinates.x
	var y = cellCoordinates.y
	
	if x < 0 || x >= boardWidth:
		return false
	
	if y < 0 || y >= boardHeight:
		return false
	
	boardLevel[y][x] = entity
	
	#print("Level #" + str(levelIndex) + ": " + entity.name + ":" + str(x) + "," + str(y))
	
	return true

func printBoard(board: Array):
	print("Board contents:")
	
	var levelIndex = -1
	for level in board:
		levelIndex += 1
		
		print("Level#" + str(levelIndex) + ":")
		for row in level:
			var rowString = ""
			
			for cell in row:
				var cellCharacter = ' '
				if cell is Block:
					cellCharacter = 'X'
				
				rowString += cellCharacter
			
			print(rowString)
