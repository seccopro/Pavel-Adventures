extends State

class_name IdleState


func on_enter():
	pass

func state_process(delta):	
	character.velocity.x = move_toward(character.velocity.x, 0, 50)	#make sure we are stopped (like after dash and jump)
	if(not character.is_on_floor()):			#TO AIR STATE (by falling)
		next_state = air_state




func state_input(event: InputEvent):
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")): #TO WALKING STATE
		next_state = walking_state

	if (Input.is_action_just_pressed("jump")):	#TO AIR STATE (by jumping)
		jump()

	if(Input.is_action_just_pressed("dash")):
		dash()
	
	if(Input.is_action_just_pressed("climb") and character.is_on_wall()):	#TO CLIMBING STATE
		next_state = climbing_state
	
	if( Input.is_action_just_pressed("magic_orb") and not $"../Casting/magic_handler".magic_orb_is_on_cooldown ):
		$"../Casting/magic_handler".cast("magic_orb", $".")
		next_state = casting_state
	if( Input.is_action_just_pressed("dark_sphere") and not $"../Casting/magic_handler".dark_sphere_is_on_cooldown ):
		$"../Casting/magic_handler".cast("dark_sphere", $".")
		next_state = casting_state

func on_exit():
	pass

func jump():
	character.velocity.y = get_parent().JUMP_VELOCITY		
#	anim.play("jump_start")         #plays one animation then loops the second                    
#	anim.queue("fall_loop")
	next_state = air_state

func dash():
	character.velocity.x = get_parent().DASH_VELOCITY #should be based on facing direction (300 is walking speed)
	next_state = dashing_state
