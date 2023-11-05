class_name Input_Check extends Node

var controls : Dictionary

func permission_checker(state: State, event) -> void:
	if state.can_move:		
		if state != $"../Air":		#movement is handled differently in air
			#TO WALKING STATE
			walk(state, event)

	if state.can_jump:
		#TO AIR STATE (by jumping)
		jump(state, event)
	
	if state.can_dash:
		#TO DASHING STATE
		dash(state, event)
	
	if state.can_climb:	#can't climb "as in start climbing" because it's already climbing
		#TO CLIMBING STATE
		climb(state, event)
	
	if state.can_cast:
		#TO CASTING STATE (magic orb and dark sphere)
		cast(state, event)

func walk(state: State, event: InputEvent) -> void:
	var move : float = Input.get_axis(controls.move_left, controls.move_right)
	if !is_zero_approx(move): #TO WALKING STATE
		state.next_state = state.walking_state

func jump(state: State, event: InputEvent) -> void:
	if Input.is_action_just_pressed(controls.jump):
		get_parent().character.velocity.y = get_parent().JUMP_VELOCITY
		$"../../AnimationTree".set("parameters/air_state/transition_request", "jump_state")
		state.next_state = state.air_state

func dash(state: State, event: InputEvent) -> void:
	if Input.is_action_just_pressed(controls.dash):		
		if $"../..".is_facing_right:
			get_parent().character.velocity.x = +get_parent().DASH_VELOCITY		#dash right
		else:
			get_parent().character.velocity.x = -get_parent().DASH_VELOCITY		#dash left
		
		state.next_state = state.dashing_state

func climb(state: State, event: InputEvent) -> void:
	if Input.is_action_just_pressed(controls.climb) \
		&& get_parent().character.is_on_wall() \
		&& !get_parent().just_detached:
		state.next_state = state.climbing_state

func cast(state: State, event: InputEvent) -> void:
	#cast magic blast
	if Input.is_action_just_pressed(controls.magic_blast) && !$"../Casting/magic_handler".magic_orb_is_on_cooldown:
		$"../Casting/magic_handler".cast("magic_blast", state)
		state.next_state = state.casting_state
	#cast magic orb
	if Input.is_action_just_pressed(controls.magic_orb) && !$"../Casting/magic_handler".magic_orb_is_on_cooldown:
		$"../Casting/magic_handler".cast("magic_orb", state)
		state.next_state = state.casting_state
	#cast dark sphere		NOT USABLE IN CURRENT FORM ,SHOULD BE MAPPED ON SPECIAL_2 OR JUST CONTROLS.MAGIC_ORB
	if Input.is_action_just_pressed(controls.spell_2) && !$"../Casting/magic_handler".dark_sphere_is_on_cooldown:
		$"../Casting/magic_handler".cast("dark_sphere", state)
		state.next_state = state.casting_state
