extends State

class_name IdleState

@export var WALKING_SPEED : float = 300
@export var JUMP_VELOCITY : float = -400


func state_input(event: InputEvent):
	if (Input.is_action_just_pressed("jump")):
		jump()


func jump():
	character.velocity.y = JUMP_VELOCITY		
#	anim.play("jump_start")         #plays one animation then loops the second                    
#	anim.queue("fall_loop")
	next_state = jumping_state
