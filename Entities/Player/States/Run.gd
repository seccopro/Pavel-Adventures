class_name StateRun
extends State

# TODO(pmerku): player.cfg
const run_velocity: float = 450.0
const run_velocity_cap: float = 600.0

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	player.animation_tree.set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	player.animation_tree.set("parameters/ground_air/transition_request", "movement")
	player.animation_tree.set("parameters/movement/transition_request", "run_state")

func exit() -> void:
	player.animation_tree.set("parameters/run_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if (abs(player.velocity.x) < run_velocity_cap) and direction:
		player.velocity.x = move_toward(player.velocity.x, direction * run_velocity, delta)
		player.animation_tree.set("parameters/run_state/transition_request", "run")
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, delta)
	
	if not player.is_on_floor:
		transition_to.emit(self, "air")
	elif is_zero_approx(player.velocity.x):
		player.animation_tree.set("parameters/run_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		transition_to.emit(self, "idle")
