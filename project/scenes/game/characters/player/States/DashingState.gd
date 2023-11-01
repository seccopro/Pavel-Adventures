extends State

class_name DashingState

var time_elapsed:float 
var dash_duration:float = 0.5
#IMHO should be able to jump to interrupt a dash

func on_enter():
	pass

func state_process(delta):
	time_elapsed += delta
	character.velocity.y = 0
	if(character.velocity.x == 0):
		if(character.is_on_floor()):
			next_state = idle_state		#TO IDLE STATE
		else:
			next_state = air_state		#TO AIR STATE (by falling)
	if(time_elapsed >= dash_duration):
		next_state = walking_state

func state_input(event : InputEvent):
	if( Input.is_action_just_pressed("magic_orb") and not $"../Casting/magic_handler".magic_orb_is_on_cooldown ):
		$"../Casting/magic_handler".magic_orb("magic_orb", $".")
		next_state = casting_state
	if( Input.is_action_just_pressed("dark_sphere") and not $"../Casting/magic_handler".dark_sphere_is_on_cooldown ):
		$"../Casting/magic_handler".magic_orb("dark_sphere", $".")
		next_state = casting_state

func on_exit():
	time_elapsed = 0
