extends State

class_name WalkingState


func on_enter():
	pass

func state_input(event: InputEvent):
	$"../input_check".permission_checker($".", event)

func state_process(delta):
	walk()
	
	if(not character.is_on_floor()):	#TO AIR STATE (by falling)
		next_state = air_state
	elif(character.velocity.x == 0):	#stopped walking #TO IDLE STATE
		next_state = idle_state

func on_exit():
	pass



func walk():
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction* get_parent().MOVING_SPEED	
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)		
