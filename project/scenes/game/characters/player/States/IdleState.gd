class_name IdleState extends State


func on_enter() -> void:
	animation_tree.set("parameters/ground_air/transition_request", "movement")
	animation_tree.set("parameters/movement/transition_request", "idle")

func state_process(delta: float) -> void:	
	character.velocity.x = move_toward(character.velocity.x, 0, 50)	#make sure we are stopped (like after dash and jump)
	if !character.is_on_ground:			#TO AIR STATE (by falling)
		next_state = air_state

func state_input(event: InputEvent) -> void:
	input_check.permission_checker($".", event)

func on_exit() -> void:
	CSM.previous_state = self

func die() -> void:
	next_state = dead_state
