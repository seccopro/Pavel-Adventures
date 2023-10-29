extends State

class_name IdleState


@export var JUMP_VELOCITY : float = -400
@export var  DASH_VELOCITY: float = 5

func on_enter():
	pass

func state_process(delta):	
	character.velocity.x = move_toward(character.velocity.x, 0, 50)	#make sure we are stopped (like after dash and jump)
	if(not character.is_on_floor()):			#TO AIR STATE (by falling)
		next_state = air_state




func state_input(event: InputEvent):
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")): #TO WALKING STATE
		next_state = walking_state

	if (Input.is_action_just_pressed("jump")):	#TO AIR STATE (by jumping
		jump()

	if(Input.is_action_just_pressed("dash")):
		dash()
	
	if(Input.is_action_just_pressed("climb") and character.is_on_wall()):	#TO CLIMBING STATE (NO WORK YET)
		next_state = climbing_state
	
	if(Input.is_action_just_pressed("cast") and character.is_on_wall()):	#TO CASTING STATE (NO WORK YET)
		next_state = casting_state

func on_exit():
	pass

func jump():
	character.velocity.y = JUMP_VELOCITY		
#	anim.play("jump_start")         #plays one animation then loops the second                    
#	anim.queue("fall_loop")
	next_state = air_state

func dash():
	character.velocity.x = DASH_VELOCITY * 300 #should be based on facing direction (300 is walking speed)
	next_state = dashing_state
