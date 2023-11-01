extends State

class_name DashingState

var time_elapsed:float 
var dash_duration:float = 0.5
#IMHO should be able to jump to interrupt a dash

func on_enter():
	pass

func state_input(event : InputEvent):
	$"../input_check".permission_checker($".", event)

func state_process(delta):
	time_elapsed += delta
	character.velocity.y = 0	#locks height
	
	if(character.velocity.x == 0):	#if stuck  => end dash
		if(character.is_on_floor()):
			next_state = idle_state		#TO IDLE STATE
#		else:							#goes to air state anyway, if in idle is not on floor
#			next_state = air_state		#TO AIR STATE (by falling)
			
	if(time_elapsed >= dash_duration):	#when finished dashing, goes to walking (if not on floor will go in air trough walking state)
		next_state = walking_state


func on_exit():
	time_elapsed = 0
