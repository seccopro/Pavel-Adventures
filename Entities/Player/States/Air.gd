class_name AirState
extends PlayerState

var _can_double_jump: bool = false

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.can_double_jump:
		player.can_double_jump = false
		transition_to.emit(self, "jump")

func physics_update(delta: float) -> void:
	player.direction = Input.get_axis("move_left", "move_right") * player.speed
	player.apply_physics(delta)
	
	if player.is_on_floor():
		if is_equal_approx(player.direction, 0.0):
			transition_to.emit(self, "idle")
		elif player.speed > player.player_stats.walk_speed:
			transition_to.emit(self, "run")
		else:
			transition_to.emit(self, "walk")
