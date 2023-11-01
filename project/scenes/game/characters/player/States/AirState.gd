extends State

class_name AirState

var has_double_jumped : bool = false

func on_enter():
	pass



func state_input(event: InputEvent): #double jump
	if(Input.is_action_just_pressed("jump")):
		if(not has_double_jumped):
			double_jump()

	if(Input.is_action_just_pressed("dash")):#TO DASH STATE
		dash()
	
	if( Input.is_action_just_pressed("magic_orb") and not $"../Casting/magic_handler".magic_orb_is_on_cooldown ):
		$"../Casting/magic_handler".cast("magic_orb", $".")
		next_state = casting_state
	if( Input.is_action_just_pressed("dark_sphere") and not $"../Casting/magic_handler".dark_sphere_is_on_cooldown ):
		$"../Casting/magic_handler".cast("dark_sphere", $".")
		next_state = casting_state

func state_process(delta):
	if(can_move):
		movement()
	#change state
	if(character.is_on_floor()):
		if(character.velocity.x == 0):
			next_state = idle_state			#TO IDLE STATE
		else:
			next_state = walking_state		#TO WALKING STATE
	
	if(Input.is_action_pressed("climb") and character.is_on_wall() and not get_parent().just_detached):	#TO CLIMBING STATE
		next_state = climbing_state


func movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction* get_parent().MOVING_SPEED	
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	

func double_jump():
	character.velocity.y = get_parent().DOUBLE_JUMP_VELOCITY
	has_double_jumped = true

func dash():
	if(character.velocity.x < 0): 	#moving left WILL CHANGE WITH ANIM FANCING
		character.velocity.x = -get_parent().DASH_VELOCITY	#add dir
	else:
		character.velocity.x = +get_parent().DASH_VELOCITY
	next_state = dashing_state
	
func on_exit():
	if(next_state == idle_state or next_state == walking_state):
		has_double_jumped = false
