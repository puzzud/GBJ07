extends Node2D
class_name Game

var board = Array()

func _ready():
	Global.game = self
	
	Global.levelNumber += 1
	
	buildBoardFromStage($Stage)
	
	updateUi()

func buildBoardFromStage(stage: Node2D):
	var contents = stage.get_node("Contents")
	for level in contents.get_children():
		for entity in level.get_children():
			if entity is Block:
				var cellCoordinates = getCellCoordinatesFromBlock(entity)
				print(entity.name + ":" + str(cellCoordinates.x) + "," + str(cellCoordinates.y))

func getCellCoordinatesFromBlock(block) -> Vector2:
	var coordinates = Vector2()
	coordinates.x = block.position.x / 16
	coordinates.y = (block.position.y + 8) / 8
	return coordinates

func onEndLevelTimerTimeout():
	print("End of level timer finished.")
	
	print("Restarting level.")
	get_tree().reload_current_scene()

func updateUi():
	$UI/LevelNumber.text = str(Global.levelNumber)
