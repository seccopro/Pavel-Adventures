class_name AirState extends State


#@onready var double_jump_velocity: float = get_parent().double_jump_velocity
#@onready var moving_speed: float = get_parent().moving_velocity
#@onready var jump_speed: float = get_parent().jump_velocity


var true_gravity: float = 980	#gets set to player gravity in on enter


var fast_fall_gravity_multiplier: float = 2.0
var fall_velocity_cap: float = 1000

var has_jump_forgiveness: bool = true
var jump_forgiveness_time: float = 0.1   #seconds
var has_double_jumped: bool = false

var time_elapsed: float = 0

func on_enter() -> void:
	true_gravity = player.gravity
	animation_tree.set("parameters/ground_air/transition_request", "air_state")
	if character.velocity.y < 0:	#if speed is negative, we are jumping, therefore play jumping animation 
		animation_tree.set("parameters/air_state/transition_request", "jump_state")
	else:	#likewise, if velocity is positve we must be falling, therefore play falling animation
		animation_tree.set("parameters/air_state/transition_request", "fall_state")
	

func state_process(delta: float) -> void:
	time_elapsed += delta
	if (time_elapsed >= jump_forgiveness_time): 	#removes coyote time
		has_jump_forgiveness = 0
	#hold for higher jump, variable max height
	jump_logic()
	movement()  	#instead of walking state
	
	#change state
	if character.is_on_ground:
		if character.velocity.x == 0:
			next_state = idle_state			#TO IDLE STATE
		else:
			next_state = walking_state		#TO WALKING STATE


func state_input(event: InputEvent) -> void:
	#all possible movements
	input_check.permission_checker($".", event)	
	
	#jump forgiveness and double jump-----------------------------------------
	if Input.is_action_just_pressed(controls.jump):	
		if has_jump_forgiveness:		#jump with forgiveness (after leaving platform)
			print("forgiven")
			input_check.jump($".", event)
		elif !has_double_jumped && form_sm.current_form == form_sm.gravity_form:#double jump only in gra
			double_jump()

func jump_logic() -> void:
	if Input.is_action_just_released(controls.jump) && character.velocity.y < 0:
		character.velocity.y /= 2           #smooths the player before falling after releasing jump
	
	if character.velocity.y > -600:                     #while ascending:
		if character.velocity.y < fall_velocity_cap:	#faster fall
			character.gravity = true_gravity * fast_fall_gravity_multiplier
		else:                                           #fall speed cap
			character.velocity.y = fall_velocity_cap
			character.gravity = true_gravity

func movement() -> void:	
	#slows down (gradually) after a wall jump  (to avoid getting the bonus speed overridden by basic movement)
	var direction = Input.get_axis(controls.move_left, controls.move_right)
	if abs(character.velocity.x) < 600 && direction:	#replace 600 with top moving speed maybe
			character.velocity.x = direction * variables.moving_velocity
			if player.can_flip_sprite :
				if direction > 0:
					player.is_facing_right = true
				else:
					player.is_facing_right = false
	else:	#stop moving
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	

func double_jump() -> void:
	character.gravity = true_gravity
	character.velocity.y = variables.double_jump_velocity
	animation_tree.set("parameters/air_state/transition_request", "jump_state")
	animation_tree.set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	has_double_jumped = true

func on_exit() -> void:
	time_elapsed = 0
	character.gravity = true_gravity
	
	if next_state == idle_state || next_state == walking_state: 	#reset double jump and LAND
		has_double_jumped = false
		has_jump_forgiveness = true
		animation_tree.set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		animation_tree.set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	CSM.previous_state = $"."
