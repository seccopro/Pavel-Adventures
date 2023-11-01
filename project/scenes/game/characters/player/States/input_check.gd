extends Node

var anim : AnimationPlayer

func permission_checker(state: State, event):	
	if(state.can_move):		
		if(!state == $"../Air"):		#movement is handled differently in air
			#TO WALKING STATE
			walk(state, event)

	if(state.can_jump):
		#TO AIR STATE (by jumping)
		jump(state, event)
	
	if(state.can_dash):
		#TO DASHING STATE
		dash(state, event)
	
	if(state.can_climb):	#can't climb "as in start climbing" because it's already climbing
		#TO CLIMBING STATE
		climb(state, event)
	
	if(state.can_cast):
		#TO CASTING STATE (magic orb and dark sphere)
		cast(state, event)


func walk(state: State, event: InputEvent):
	if (Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left")): #TO WALKING STATE
		state.next_state = state.walking_state

func jump(state: State, event: InputEvent):
	if (Input.is_action_just_pressed("jump")):
		get_parent().character.velocity.y = get_parent().JUMP_VELOCITY
		#anim.play("jump_start")	#on enter in air state
		state.next_state = state.air_state

func dash(state: State, event: InputEvent):
	if(Input.is_action_just_pressed("dash")):		
		if(get_parent().character.velocity.x < 0): 	#moving left WILL CHANGE WITH ANIM FANCING
			get_parent().character.velocity.x = -get_parent().DASH_VELOCITY	#add dir
		else:
			get_parent().character.velocity.x = +get_parent().DASH_VELOCITY
		
		state.next_state = state.dashing_state

func climb(state: State, event: InputEvent):
	if( Input.is_action_just_pressed("climb") and \
	get_parent().character.is_on_wall() and \
	not get_parent().just_detached ):
		state.next_state = state.climbing_state

func cast(state: State, event: InputEvent):
	#cast magic orb
	if( Input.is_action_just_pressed("magic_orb") and not $"../Casting/magic_handler".magic_orb_is_on_cooldown ):
		$"../Casting/magic_handler".cast("magic_orb", state)
		state.next_state = state.casting_state
	#cast dark sphere
	if( Input.is_action_just_pressed("dark_sphere") and not $"../Casting/magic_handler".dark_sphere_is_on_cooldown ):
		$"../Casting/magic_handler".cast("dark_sphere", state)
		state.next_state = state.casting_state


