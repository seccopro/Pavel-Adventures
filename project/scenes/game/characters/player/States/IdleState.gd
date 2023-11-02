class_name IdleState extends State

func on_enter() -> void:
	$"../../AnimationTree".set("parameters/ground_air/transition_request", "movement")
	$"../../AnimationTree".set("parameters/movement/transition_request", "idle")
	pass

func state_process(delta: float) -> void:	
	character.velocity.x = move_toward(character.velocity.x, 0, 50)	#make sure we are stopped (like after dash and jump)
	if !character.is_on_floor():			#TO AIR STATE (by falling)
		next_state = air_state

func state_input(event: InputEvent) -> void:
	$"../input_check".permission_checker($".", event)

func on_exit() -> void:
	pass

func die() -> void:
	next_state = dead_state
