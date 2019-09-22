extends Node2D
class_name Stage

const cellWidth = 16
const cellHeight = 8

export(int) var boardWidth = 10
export(int) var boardHeight = 15

var board = Array()

func _ready():
	board = buildBoard()

func buildBoard() -> Array:
	var board = Array()
	
	for level in $Contents.get_children():
		for entity in level.get_children():
			if entity is Block:
				var cellCoordinates = getCellCoordinatesFromBlock(entity)
				print(entity.name + ":" + str(cellCoordinates.x) + "," + str(cellCoordinates.y))
	
	return board

func getCellCoordinatesFromBlock(block) -> Vector2:
	var coordinates = Vector2()
	
	coordinates.x = int(block.position.x / cellWidth)
	# TODO: +8 should come from block, as its offset.
	coordinates.y = int((block.position.y + 8) / cellHeight)
	
	return coordinates
