class_name StateIdle
extends State

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	player.direction = 0.0

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		transition_to.emit(self, "run")
	
	if event.is_action_pressed("jump") and player.is_on_floor():
		transition_to.emit(self, "jump")

func physics_update(delta: float) -> void:
	player.apply_physics(delta)
	
	if not player.is_on_floor():
		transition_to.emit(self, "air")
