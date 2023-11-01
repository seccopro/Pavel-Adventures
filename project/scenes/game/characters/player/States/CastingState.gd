extends State

class_name CastingState



var time_elapsed : float = 0.0



func on_enter():
	character.velocity.y=0
	character.velocity.x =0

func state_process(delta):
	time_elapsed += delta
	if(time_elapsed >= $magic_handler.cast_duration):
		next_state = $magic_handler.previous_state


func on_exit():
	time_elapsed = 0
