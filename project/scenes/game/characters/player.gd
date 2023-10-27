extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CLIMBING_SPEED = 100.0
const DASH_SPEED = 5
const DASH_DURATION = 30
var remaining_dashing = 0
var double_jumped = false
var prev_pos = 0

var lifes = 3

#flags
var is_climbing = false 
var is_dashing = false
var is_alive = true
var is_playing = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and not is_climbing:	#gravity / falling
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("reset_position"):		#reset respawn mech add button
		reset_position()
	
	if(is_alive and is_playing):
		logic()
		move_and_slide()
		movement()

func logic():
	var hearts = ""
	for i in lifes:
		hearts += "♥"
	$"HP_bar".text = str(hearts)
	if(lifes <= 0):
		game_over()
		
func game_over():
	$"death_screen".show()
	is_alive = false
	is_playing = false
	print("gay over")

func win():
	is_playing = false
	$"victory_screen".show()
	
func reset_position():
		position.x = 550
		position.y = 400
		

func movement():
	#basic left and right
	var direction = Input.get_axis("left", "right")
	if direction and not is_climbing and not is_dashing:	#locked during climb and dash
		velocity.x = direction * SPEED
	else:	#slowing down after releasing
		velocity.x = move_toward(velocity.x, 0, 50)
	
#Handle Jump and Double Jump.
	if Input.is_action_just_pressed("jump"):
		jump();
	if double_jumped and (is_on_floor() or is_climbing):
		double_jumped = false

	if Input.is_action_just_pressed("dash") and not is_dashing and not is_climbing: #maybe to add dash cooldown 
		dash()
	elif is_dashing:
		dash_reset()	#to reset movement after dash
			
	#start climbing / attach to the wall
	if Input.is_action_pressed("climb") and is_on_wall():
		is_climbing = true
	if is_climbing:
		climb()
		
func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif not double_jumped:
		velocity.y = JUMP_VELOCITY		#could change the second jump velocity
		double_jumped = true;

func climb():	
#climb up and down			
	var climb_direction = Input.get_axis("up", "down")		
	if climb_direction:
		velocity.y = climb_direction * CLIMBING_SPEED
	else:	#slowing down after releasing
		velocity.y = 0
#
# Handle climb-jump
	if Input.is_action_just_pressed("jump"):	#should jump to the direction opposite of the wall
		velocity.y = JUMP_VELOCITY
		is_climbing = false
		
#stop climbing, any moment that you aren't touching the wall	
	if not is_on_wall():		#kinda fucks when on top
		print("too far from wall")
		is_climbing=false

func dash():	#to add to facing direction
		#dash while moving right (checking input, not momentum, nor character facing direction)
		velocity.x *= DASH_SPEED
		is_dashing = true
		remaining_dashing = DASH_DURATION
		
#		if(Input.is_action_pressed("right")): 
#			is_dashing = true
#			velocity.x += DASH_SPEED
#			remaining_dashing = DASH_DURATION
#	#dash while moving left (checking input, not momentum, nor character facing direction)
#		elif (Input.is_action_pressed("left")): 
#			is_dashing = true
#			velocity.x -= DASH_SPEED
#			remaining_dashing = DASH_DURATION
			#var prev pos
func dash_reset():
	if(prev_pos == position.x): #check if dash has been interrupted
		remaining_dashing=0;
		is_dashing=false
		print("dash reset")	
	else:
		prev_pos = position.x; #spomni kje je bilposizione v frame 1	(10)
	#waiting for dash to finish	
		if remaining_dashing>0:
			remaining_dashing-=1 #waits for  ${DASH_DURATION} (30) cicles to let you move again (reset your speed)
		else:
			is_dashing=false
			print("dash reset")		

func _on_node_2d_damaged():
	lifes -= 1 

func _on_ronda_touched(value):
	lifes -= value


func _on_node_2d_win(score):
	win()
