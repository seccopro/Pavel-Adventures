class_name StateRun
extends State

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	player.animation_tree.set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	player.animation_tree.set("parameters/ground_air/transition_request", "movement")
	player.animation_tree.set("parameters/movement/transition_request", "run_state")

func exit() -> void:
	player.animation_tree.set("parameters/run_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.is_on_floor():
		transition_to.emit(self, "jump")

func physics_update(delta: float) -> void:
	player.direction = Input.get_axis("move_left", "move_right") * player.WALK_SPEED
	player.apply_physics(delta)
	
	if not player.is_on_floor():
		transition_to.emit(self, "air")
	if is_equal_approx(player.direction, 0.0):
		transition_to.emit(self, "idle")
