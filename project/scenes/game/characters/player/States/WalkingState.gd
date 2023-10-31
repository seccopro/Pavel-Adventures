extends State

class_name WalkingState


func on_enter():
	pass

func state_input(event: InputEvent):
	if(event.is_action_pressed("jump")):	#TO AIR STATE (by jump)
		jump()

	if(Input.is_action_just_pressed("dash")):#TO DASH STATE
		dash()

	if(Input.is_action_just_pressed("climb") and character.is_on_wall()):	#TO CLIMBING STATE
		next_state = climbing_state
	
	if( Input.is_action_just_pressed("magic_orb") and not $"../Casting/magic_handler".magic_orb_is_on_cooldown ):
		$"../Casting/magic_handler".cast("magic_orb", $".")
		next_state = casting_state
	if( Input.is_action_just_pressed("dark_sphere") and not $"../Casting/magic_handler".dark_sphere_is_on_cooldown ):
		$"../Casting/magic_handler".cast("dark_sphere", $".")
		next_state = casting_state

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

func jump():
	character.velocity.y = get_parent().JUMP_VELOCITY		
#	anim.play("jump_start")         #plays one animation then loops the second                    
#	anim.queue("fall_loop")
	next_state = air_state

func dash():
	if(character.velocity.x < 0): 	#moving left WILL CHANGE WITH ANIM FANCING
		character.velocity.x = -get_parent().DASH_VELOCITY	#add dir
	else:
		character.velocity.x = +get_parent().DASH_VELOCITY
	next_state = dashing_state
