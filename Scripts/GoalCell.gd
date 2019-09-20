extends Node2D

func _ready():
	pass

func onBodyEntered(body):
	print("Entity entered: " + name)
	
	print("Starting game end level timer.")
	var timer:Timer = Global.game.get_node("Timers/EndLevelTimer")
	if timer != null:
		timer.start()
