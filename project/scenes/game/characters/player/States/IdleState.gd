extends State

class_name IdleState


func on_enter():
	pass

func state_process(delta):	
	character.velocity.x = move_toward(character.velocity.x, 0, 50)	#make sure we are stopped (like after dash and jump)
	if(not character.is_on_floor()):			#TO AIR STATE (by falling)
		next_state = air_state
	

func state_input(event: InputEvent):
	$"../input_check".permission_checker($".", event)

func on_exit():
	pass

func die():
	next_state = dead_state
