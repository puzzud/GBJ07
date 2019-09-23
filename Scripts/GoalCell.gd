extends Node2D

func _ready():
	pass

func onBodyEntered(body):
	# TODO: Do this with collision layer & mask?
	if !(body is Hero):
		return
	
	print("Entity entered: " + name)
	
	print("Starting game end level timer.")
	var timer:Timer = Global.game.get_node("Timers/EndLevelTimer")
	if timer != null:
		timer.start()
