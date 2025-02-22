class_name AirState
extends State

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func unhandled_input(event: InputEvent) -> void:
	pass

func physics_update(delta: float) -> void:
	player.apply_physics(delta)
	
	if player.is_on_floor():
		if is_equal_approx(player.direction, 0.0):
			transition_to.emit(self, "idle")
		else:
			transition_to.emit(self, "run")
