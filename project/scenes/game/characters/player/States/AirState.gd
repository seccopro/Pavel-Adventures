class_name AirState extends State


@onready var double_jump_velocity: float = get_parent().double_jump_velocity
@onready var moving_speed: float = get_parent().moving_velocity


var true_gravity: float = 980	#gets set to player gravity in on enter

var start_jump_y: float = 0.0
var min_jump_height: float = -150 #delta y
var high_jump_velocity_increase: float = -100
var max_jump_height: float = -250  	#delta y

var hang_time_range_height: float =  max_jump_height + 0.5
var hang_time_gravity_multiplier: float = 1.5

var fast_fall_gravity_multiplier: float = 5
var fall_velocity_cap: float = 2000
var has_jump_forgiveness: bool = true
var jump_forgiveness_time: float = 0.1	#seconds
var higher_jump_finished: bool = false
var has_double_jumped: bool = false

var time_elapsed: float = 0

func on_enter() -> void:
	true_gravity = player.gravity
	start_jump_y = character.global_position.y
	animation_tree.set("parameters/ground_air/transition_request", "air_state")



func state_process(delta: float) -> void:
	time_elapsed += delta
	if (time_elapsed >= jump_forgiveness_time): 	#removes coyote time
		has_jump_forgiveness = 0
	#hold for higher jump, variable max height
	jump_logic()
	movement()  	#instead of walking state

	#change state
	if character.is_on_floor():
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

	#start jump
	if !higher_jump_finished && Input.is_action_pressed(controls.jump):
	#hold jump for higher jump
		if character.global_position.y > start_jump_y + max_jump_height:	#>NEGATIVE VALUE 
			character.velocity.y += high_jump_velocity_increase
		else:	#highest point reached
			higher_jump_finished = true
			character.velocity.y = 0
	#release jump, for short jump
	if !Input.is_action_pressed(controls.jump): 
		higher_jump_finished = true
		# > min jump height
		if character.global_position.y < start_jump_y + min_jump_height && character.velocity.y < 0:
			character.velocity.y = 0
	
	#stop jump if collided with any object
	if character.velocity.y > -10:
		higher_jump_finished = true
	
	#hang time	(only for long jump)	
	if character.global_position.y < start_jump_y + hang_time_range_height && character.global_position.y > max_jump_height:
		character.gravity = true_gravity * hang_time_gravity_multiplier
	
	#falling
	if character.velocity.y > 0:
		if character.velocity.y < fall_velocity_cap:	#fast falling 
			character.gravity = true_gravity * fast_fall_gravity_multiplier
		else:											#fall speed cap
			character.velocity.y = fall_velocity_cap
			character.gravity = true_gravity

func movement() -> void:
	var direction = Input.get_axis(controls.move_left, controls.move_right)
	if direction:
		character.velocity.x = direction * moving_speed
		if player.can_flip_sprite :
			if direction > 0:
				player.is_facing_right = true
			else:
				player.is_facing_right = false
	else:	#stop moving
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	


func double_jump() -> void:
	character.velocity.y = double_jump_velocity
	animation_tree.set("parameters/air_state/transition_request", "jump_state")
	animation_tree.set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	has_double_jumped = true
	print("double jump")
	#reset jump logic
	start_jump_y = character.global_position.y
	higher_jump_finished = false

func on_exit() -> void:
	time_elapsed = 0
	character.gravity = true_gravity
	
	if next_state == idle_state || next_state == walking_state: 	#reset double jump and LAND
		has_double_jumped = false
		has_jump_forgiveness = true
		animation_tree.set("parameters/jump_state/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		animation_tree.set("parameters/landing/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	higher_jump_finished = false
