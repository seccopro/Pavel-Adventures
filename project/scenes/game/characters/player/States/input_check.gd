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
		if state.form_sm.current_form == state.form_sm.rock_form:
			rock_dash(state, event)
		if state.form_sm.current_form == state.form_sm.fire_form:
			fire_dash(state, event)
	
	if state.can_climb: #climb as in start climbing
		#TO CLIMBING STATE
		if state.form_sm.current_form == state.form_sm.rock_form:
			climb(state, event)
	
	if state.can_cast:
		#TO CASTING STATE (magic orb and dark sphere)
		cast(state, event)
	
	if state.can_change_form:
		change_form(state, event)


#basic movement
func walk(state: State, event: InputEvent) -> void:
	var move : float = Input.get_axis(controls.move_left, controls.move_right)
	if !is_zero_approx(move): #TO WALKING STATE
		state.next_state = state.walking_state

func jump(state: State, event: InputEvent) -> void:
	if Input.is_action_just_pressed(controls.jump):
		get_parent().character.velocity.y = get_parent().JUMP_VELOCITY
		$"../../AnimationTree".set("parameters/air_state/transition_request", "jump_state")
		state.next_state = state.air_state

func attack(state: State, event: InputEvent) -> void:
	pass

#-------rock-------
#passive
	#somewhere else, can sink surviving (xand maybe extra resistances)
	
#special 1
	#cast special 1

#special 2
func climb(state: State, event: InputEvent) -> void:
	if Input.is_action_just_pressed(controls.climb) \
		&& ( get_parent().character.is_on_wall_r || get_parent().character.is_on_wall_l )  \
		&& !get_parent().just_detached:
		state.next_state = state.climbing_state

#special 3
func rock_dash(state: State, event: InputEvent) -> void:	#rock dash
	if Input.is_action_just_pressed(controls.dash):		
		print("rock dash")
		if $"../..".is_facing_right:
			get_parent().character.velocity.x = +get_parent().DASH_VELOCITY / 2		#dash right
		else:
			get_parent().character.velocity.x = -get_parent().DASH_VELOCITY / 2	#dash left
		
		state.next_state = state.dashing_state


#-------fire-------
#passive
	#somewhere else, glows and can go in cold enviroments
#special 1
	#cast special 1

#special 2
	#cast special 2

#special 3
func fire_dash(state: State, event: InputEvent) -> void:	#fire dash
	if Input.is_action_just_pressed(controls.dash):		
		print("fiery dash")
		if $"../..".is_facing_right:
			get_parent().character.velocity.x = +get_parent().DASH_VELOCITY		#dash right
		else:
			get_parent().character.velocity.x = -get_parent().DASH_VELOCITY		#dash left
		
		state.next_state = state.dashing_state

#-------gravity-------
#passive
func double_jump(state: State, event: InputEvent) -> void:
	pass

#special 1
	#cast special 1

#special 2
	#cast special 2

#special 3
	#cast special 3

#-------ice-------
#passive
	#somewhere else  - walks on water and skates instead of walking (skating is faster, but slower to stop)

#special 1
	#summon sword (cast!) (held to power-up

#special 2
	#cast special 2

#special 3
	#cast special 3






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

func change_form(state: State, event: InputEvent) -> void:
	if Input.is_action_pressed(controls.form_wheel) && Input.is_action_just_pressed(controls.change_form_1):
		state.form_sm.current_form.next_form = state.form_sm.rock_form
	if Input.is_action_pressed(controls.form_wheel) && Input.is_action_just_pressed(controls.change_form_2):
		state.form_sm.current_form.next_form = state.form_sm.fire_form
	if Input.is_action_pressed(controls.form_wheel) && Input.is_action_just_pressed(controls.change_form_3):
		state.form_sm.current_form.next_form = state.form_sm.gravity_form
	if Input.is_action_pressed(controls.form_wheel) && Input.is_action_just_pressed(controls.change_form_4):
		state.form_sm.current_form.next_form = state.form_sm.ice_form
