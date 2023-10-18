extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump_charge=0
const CLIMBING_SPEED = 100.0
const DASH_SPEED = 1000
const DASH_DURATION = 30
var remaining_dashing = 0

#flags
var is_climbing = false 
var is_dashing = false
var is_alive = true




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and not is_climbing:	#gravity / falling
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("reset_position"):		#reset respawn mech add button
		position.x = 0
		position.y = 0
	
	move_and_slide()
	movement()
	

func movement():
	#basic left and right
	var direction = Input.get_axis("left", "right")
	if direction and not is_climbing and not is_dashing:
		velocity.x = direction * SPEED
	else:	#slowing down after releasing
		velocity.x = move_toward(velocity.x, 0, 50)
# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_just_pressed("dash") and not is_climbing:		# GETS RESET BY NORMAL SPEED OF WALKING (use flag)
		if(Input.is_action_pressed("right")): #moving right
			is_dashing = true;
			velocity.x += DASH_SPEED
			remaining_dashing = DASH_DURATION
				
		elif (Input.is_action_pressed("left")): #moving left
			is_dashing = true;
			velocity.x -= DASH_SPEED
			remaining_dashing = DASH_DURATION
#waiting for dash to finish
	if is_dashing and remaining_dashing>0:
		remaining_dashing-=1 #should wait DASH_DURATION cicles to let you move again (reset your speed)
	elif is_dashing:
		is_dashing=false
		print("dash reset")	
	
	
	if is_on_wall():
		climbing()
		
func climbing():
	#start climbing
	if Input.is_action_pressed("climb"):
		is_climbing = true
		print("climbing")
	
	
	#climb up and down			
	var climb_direction = Input.get_axis("up", "down")	
	
	if is_climbing and climb_direction:
		velocity.y = climb_direction * CLIMBING_SPEED
	elif is_climbing:	#slowing down after releasing
		velocity.y = move_toward(velocity.y, 0, CLIMBING_SPEED)
	
	# Handle climb-jump
	if is_climbing and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		is_climbing = false
		print("not climbing")


