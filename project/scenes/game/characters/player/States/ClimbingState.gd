extends State

class_name ClimbingState

@export var VERTICAL_SPEED :float = 300

func on_enter():
	can_fall = false

func state_process(delta):
	if(not character.is_on_wall()):	#to idle / air state by falling
		next_state = air_state
	vertical_movement()
	

func state_input(event : InputEvent):
	if(Input.is_action_just_pressed("climb")):	#TO IDLE STATE (OR AIR)
		$"climb_detach".start()
	if(Input.is_action_just_released("climb")):
		$"climb_detach".stop()		
	
	if (Input.is_action_just_pressed("jump")):				#TO AIR STATE (by jumping)
		character.velocity.y = get_parent().JUMP_VELOCITY
		next_state = air_state
	
	if( Input.is_action_just_pressed("magic_orb") and not $"../Casting/magic_handler".magic_orb_is_on_cooldown ):
		$"../Casting/magic_handler".magic_orb("magic_orb", $".")
		next_state = casting_state
	if( Input.is_action_just_pressed("dark_sphere") and not $"../Casting/magic_handler".dark_sphere_is_on_cooldown ):
		$"../Casting/magic_handler".magic_orb("dark_sphere", $".")
		next_state = casting_state


func vertical_movement():
	var direction = Input.get_axis("up", "down")
	if direction:
		character.velocity.y = direction * VERTICAL_SPEED	
	else:
		character.velocity.y = 0

func on_exit():
	$"climb_detach".stop()
	get_parent().get_parent().can_fall = true


func _on_climb_detach_timeout():
	get_parent().just_detached = true
	$"just_detached".start()
	next_state = idle_state	
