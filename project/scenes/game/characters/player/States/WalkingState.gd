extends State

class_name WalkingState


@export var WALKING_SPEED : float = 300
@export var JUMP_VELOCITY : float = -400
@export var  DASH_VELOCITY: float = 5

func on_enter():
	pass

func state_input(event: InputEvent):
	if(event.is_action_pressed("jump")):	#TO AIR STATE (by jump)
		jump()

	if(Input.is_action_just_pressed("dash")):#TO DASH STATE
		dash()

	if(Input.is_action_just_pressed("climb") and character.is_on_wall()):	#TO CLIMBING STATE
		next_state = climbing_state
	
	if(Input.is_action_just_pressed("cast") and character.is_on_wall()):	#TO CASTING STATE (NO WORK YET)
		next_state = casting_state





func state_process(delta):
	walk()
	if(not character.is_on_floor()):	#TO AIR STATE (by falling)
		next_state = air_state		
	elif(character.velocity.x == 0):	#stopped walking #TO IDLE STATE
		next_state = idle_state 


func on_exit():
	pass



func walk():
	var direction = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction* WALKING_SPEED	
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)		

func jump():
	character.velocity.y = JUMP_VELOCITY		
#	anim.play("jump_start")         #plays one animation then loops the second                    
#	anim.queue("fall_loop")
	next_state = air_state

func dash():
	character.velocity.x *= DASH_VELOCITY
	next_state = dashing_state
