class_name WalkingState extends State

func on_enter() -> void:
	pass

func state_input(event: InputEvent) -> void:
	$"../input_check".permission_checker($".", event)

func state_process(delta: float) -> void:
	walk()
	
	if !character.is_on_floor():	#TO AIR STATE (by falling)
		next_state = air_state
	elif character.velocity.x == 0:	#stopped walking #TO IDLE STATE
		next_state = idle_state

func on_exit() -> void:
	pass

func walk() -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction * get_parent().MOVING_SPEED	
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)
