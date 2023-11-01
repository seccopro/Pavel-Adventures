extends State

class_name WalkingState


func on_enter():
	anim.play("run_start")

func state_input(event: InputEvent):
	$"../input_check".permission_checker($".", event)

func state_process(delta):
	walk()
	
	if(not character.is_on_floor()):	#TO AIR STATE (by falling)
		next_state = air_state
	elif(character.velocity.x == 0):	#stopped walking #TO IDLE STATE
		next_state = idle_state

func on_exit():
	anim.play("run_stop")



func walk():
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction * get_parent().MOVING_SPEED
		anim.queue("run")
		if(direction > 0):
			$"../..".facing_right = true
		else:
			$"../..".facing_right = false
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)
		
