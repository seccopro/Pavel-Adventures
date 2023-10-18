extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jump_charge=0
const CLIMBING_SPEED = 100.0
var is_climbing = false #flag 
var is_alive = true
var is_dashing = false

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
	climbing()

func movement():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not is_climbing:
		velocity.x = direction * SPEED
	else:	#slowing down after releasing
		velocity.x = move_toward(velocity.x, 0, 50)

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func climbing():
	#start climbing
	if Input.is_action_just_pressed("climb") and is_on_wall():
		is_climbing = true
		print("climbing")
	
	#climb up and down
		
	var climb_direction = Input.get_axis("ui_up", "ui_down")	
	
	if is_climbing and climb_direction and is_on_wall():
		velocity.y = climb_direction * CLIMBING_SPEED
	elif is_climbing:	#slowing down after releasing
		velocity.y = move_toward(velocity.y, 0, CLIMBING_SPEED)
	
	# Handle climb-jump
	if is_climbing and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		is_climbing = false
		print("not climbing")
	return true


