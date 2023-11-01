extends State

class_name DeadState

func on_enter():
	pass
	
func state_input(event : InputEvent):
	$"../input_check".permission_checker($".", event)


func state_process(delta):
	pass

func on_exit():
	pass
