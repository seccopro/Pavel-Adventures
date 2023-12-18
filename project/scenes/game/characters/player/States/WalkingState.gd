class_name WalkingState extends State

@onready var parent: Node = get_parent()

func on_enter() -> void:
	animation_tree.set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	animation_tree.set("parameters/ground_air/transition_request", "movement")
	animation_tree.set("parameters/movement/transition_request", "run_state")
	pass

func state_input(event: InputEvent) -> void:
	input_check.permission_checker($".", event)

func state_process(delta: float) -> void:
	walk()
	
	if !character.is_on_ground:	#TO AIR STATE (by falling)
		next_state = air_state
	elif character.velocity.x == 0:	#stopped walking #TO IDLE STATE
		animation_tree.set("parameters/run_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		next_state = idle_state

func on_exit() -> void:
	CSM.previous_state = self
	animation_tree.set("parameters/run_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func walk() -> void:
	var direction: float = Input.get_axis(controls.move_left, controls.move_right)
	if abs(character.velocity.x) < player_config.walking_velocity_cap && direction:
		character.velocity.x = direction * player_config.walking_velocity
		if player.can_flip_sprite :
			if direction > 0:
				player.is_facing_right = true
			else:
				player.is_facing_right = false
		animation_tree.set("parameters/run_state/transition_request", "run")
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 100)
