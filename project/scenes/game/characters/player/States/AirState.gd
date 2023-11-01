extends State

class_name AirState

var has_double_jumped : bool = false

func on_enter():
	anim.stop()
	if(character.velocity.y < 0): #jumping
		anim.play("jump_start")
	else:
		anim.play("fall_loop")



func state_input(event: InputEvent): 
	
	if(Input.is_action_just_pressed("jump")):	#double jump
		if(not has_double_jumped):
			double_jump()
	
	$"../input_check".permission_checker($".", event)	#main state changer


func state_process(delta):
	if(can_move):
		movement()		#instead of walking state

	#change state
	if(character.is_on_floor()):
		if(character.velocity.x == 0):
			next_state = idle_state			#TO IDLE STATE
		else:
			next_state = walking_state		#TO WALKING STATE
	else:
		if( character.velocity.y >= -10 and character.velocity.y <= 5 ):	#uselsess alex says
			anim.play("jump_top")
		
	if( Input.is_action_pressed("climb") and character.is_on_wall() and not get_parent().just_detached ):	#TO CLIMBING STATE
		next_state = climbing_state


func movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction* get_parent().MOVING_SPEED	
		if(direction > 0):
			$"../..".facing_right = true
		else:
			$"../..".facing_right = false
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	
	
func double_jump():
	character.velocity.y = get_parent().DOUBLE_JUMP_VELOCITY
	has_double_jumped = true
	anim.play("jump_start")

	
func on_exit():
	if(next_state == idle_state or next_state == walking_state):	#reset double jump
		anim.play("fall_end")
		has_double_jumped = false
