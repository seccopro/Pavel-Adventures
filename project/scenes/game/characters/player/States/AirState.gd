extends State

class_name AirState

@export var DOUBLE_JUMP_VELOCITY : float = -400
@export var MOVING_SPEED : float = 300
@export var  DASH_VELOCITY: float = 5

var has_double_jumped : bool = false

func on_enter():
	pass



func state_input(event: InputEvent): #double jump
	if(event.is_action_pressed("jump")):
		if(not has_double_jumped):
			double_jump()

	if(Input.is_action_just_pressed("dash")):#TO DASH STATE
		dash()

	if(Input.is_action_just_pressed("climb") and character.is_on_wall()):	#TO CLIMBING STATE
		next_state = climbing_state
	
	if(Input.is_action_just_pressed("cast") and character.is_on_wall()):	#TO CASTING STATE (NO WORK YET)
		next_state = casting_state

func state_process(delta):
	movement()
	#change state
	if(character.is_on_floor()):
		next_state = idle_state


func movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction* MOVING_SPEED	
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	

func double_jump():
	character.velocity.y = DOUBLE_JUMP_VELOCITY
	has_double_jumped = true

func dash():
	character.velocity.x *= DASH_VELOCITY
	next_state = dashing_state
	
func on_exit():
	if(next_state == idle_state):
		has_double_jumped = false
