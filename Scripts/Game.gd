extends Node2D
class_name Game


func _ready():
	Global.game = self
	
	Global.levelNumber += 1
	
	updateUi()

func onEndLevelTimerTimeout():
	print("End of level timer finished.")
	
	print("Restarting level.")
	get_tree().reload_current_scene()

func updateUi():
	$UI/LevelNumber.text = str(Global.levelNumber)
