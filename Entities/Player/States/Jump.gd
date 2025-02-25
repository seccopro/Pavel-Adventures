class_name JumpState
extends PlayerState

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	player.velocity.y = player.player_stats.jump_velocity

func exit() -> void:
	pass

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.can_double_jump:
		player.can_double_jump = false
		transition_to.emit(self, "jump")
	elif event.is_action_released("jump") and player.velocity.y < 0.0:
		player.velocity.y *= player.player_stats.jump_deceleration

func physics_update(delta: float) -> void:
	player.apply_physics(delta)
	
	if player.velocity.y >= 0.0:
		transition_to.emit(self, "air")
