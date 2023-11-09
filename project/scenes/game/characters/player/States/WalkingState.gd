class_name WalkingState extends State

func on_enter() -> void:
	$"../../AnimationTree".set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	$"../../AnimationTree".set("parameters/ground_air/transition_request", "movement")
	$"../../AnimationTree".set("parameters/movement/transition_request", "run_state")
	pass

func state_input(event: InputEvent) -> void:
	$"../input_check".permission_checker($".", event)

func state_process(delta: float) -> void:
	walk()
	
	if !character.is_on_floor():	#TO AIR STATE (by falling)
		$"../../AnimationTree".set("parameters/air_state/transition_request", "fall_state")
		$"../Air".has_jump_forgiveness = true
		next_state = air_state
	elif character.velocity.x == 0:	#stopped walking #TO IDLE STATE
		$"../../AnimationTree".set("parameters/run_state/transition_request", "run_idle")
		next_state = idle_state

func on_exit() -> void:
	pass

func walk() -> void:
	var direction = Input.get_axis(controls.move_left, controls.move_right)
	if direction:
		character.velocity.x = direction * get_parent().MOVING_SPEED
		if $"../..".can_flip_sprite :
			if direction > 0:
				$"../..".is_facing_right = true
			else:
				$"../..".is_facing_right = false
		$"../../AnimationTree".set("parameters/run_state/transition_request", "run")
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)
