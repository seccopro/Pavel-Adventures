extends State

class_name JumpingState

@export var DOUBLE_JUMP_VELOCITY : float = -400

var has_double_jumped : bool = false

func on_enter():
	pass

func state_process(delta):
	#change state
	if(character.is_on_floor()):
		next_state = idle_state

func state_input(event: InputEvent): #double jump
	if(event.is_action_pressed("jump")):
		if(not has_double_jumped):
			double_jump()

func double_jump():
	character.velocity.y = DOUBLE_JUMP_VELOCITY
	has_double_jumped = true



func on_exit():
	if(next_state == idle_state):
		has_double_jumped = false
