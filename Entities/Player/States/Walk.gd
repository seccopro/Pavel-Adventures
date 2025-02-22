class_name StateWalk
extends PlayerState

# TODO(primoz): namesto timer, bi lahko dobil signal is walking anim
var _timer: SceneTreeTimer

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	player.animation_tree.set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	player.animation_tree.set("parameters/ground_air/transition_request", "movement")
	player.animation_tree.set("parameters/movement/transition_request", "walk_state")
	
	player.speed = player.player_stats.walk_speed
	
	_timer = get_tree().create_timer(0.3)
	_timer.timeout.connect(on_timer_timeout)

func exit() -> void:
	player.animation_tree.set("parameters/run_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.is_on_floor():
		transition_to.emit(self, "jump")

func physics_update(delta: float) -> void:
	player.direction = Input.get_axis("move_left", "move_right") * player.speed
	player.apply_physics(delta)
	
	if not player.is_on_floor():
		transition_to.emit(self, "air")
	if is_equal_approx(player.direction, 0.0):
		transition_to.emit(self, "idle")

func on_timer_timeout() -> void:
	transition_to.emit(self, "run")
