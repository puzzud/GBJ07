extends Node
class_name Stage

const cellWidth = 1.5
const cellHeight = 1.5

export(int) var boardWidth = 10
export(int) var boardHeight = 16

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
			if entity is Hero:
				continue
			if entity is Entity:
				if !insertEntityIntoBoardLevel(boardLevel, levelIndex, entity):
					printerr("Failed to insert \"" + entity.name + "\" into level #" + str(boardLevel) + ".")
			elif entity.name == "Blocks":
				for block in entity.get_children():
					if !insertEntityIntoBoardLevel(boardLevel, levelIndex, block):
						printerr("Failed to insert \"" + entity.name + "\" into level #" + str(boardLevel) + ".")
		
		board.push_back(boardLevel)
		
	return board

func getCellCoordinatesFromBlock(block) -> Vector2:
	var coordinates = Vector2()
	
	var blockPosition = block.get_global_transform().origin
	coordinates.x = int(blockPosition.x / cellWidth)
	# TODO: +8 should come from block, as its offset.
	coordinates.y = int((blockPosition.y) / cellHeight)
	
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
	
	if entity is Block:
		var block: Block = entity
		block.boardLevelIndex = levelIndex
		block.boardCellCoordinates = cellCoordinates
	
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
