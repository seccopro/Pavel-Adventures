class_name DeadState extends State

#@onready var CSM = $".."

func on_enter() -> void:
	pass
	
func state_input(event : InputEvent) -> void:
	input_check.permission_checker($".", event)

func state_process(delta: float) -> void:
	pass

func on_exit() -> void:
	CSM.previous_state = self
