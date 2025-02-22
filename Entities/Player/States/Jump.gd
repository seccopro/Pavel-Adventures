class_name JumpState
extends State

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	player.velocity.y = player.JUMP_VELOCITY

func exit() -> void:
	pass

func unhandled_input(event: InputEvent) -> void:
	player.direction = Input.get_axis("move_left", "move_right") * player.WALK_SPEED

func physics_update(delta: float) -> void:
	player.apply_physics(delta)
	
	if player.velocity.y >= 0.0:
		transition_to.emit(self, "air")
