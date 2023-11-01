extends CharacterBody2D

#variables _______________________________________________________________________________________________
#on ready
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var anim_state_machine: CharacterStateMachine = $AnimationTree.get("parameters/playback")
@onready var anim_tree : AnimationTree = $AnimationTree

#constants
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const CLIMBING_SPEED: float = 100.0
const DASH_SPEED: float = 5.0
const DASH_DURATION: float = 30.0

#variables for game logic
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") # Get the gravity from the project settings to be synced with RigidBody nodes.
var remaining_dashing: float = 0.0
var double_jumped: bool = false
var prev_pos: float = 0.0
var lifes: int = 3

#flags
var is_climbing: bool = false 
var is_dashing: bool = false
var is_alive: bool = true
var is_playing: bool = true

#functions ___________________________________________________________________________________________________________________________
func _physics_process(delta: float) -> void:		#"MAIN" runs every delta time - CALLS ALL OTHER FUNCTIONS
	# Add the gravity.
	if !is_on_floor() && !is_climbing:	#gravity / falling
		velocity.y += gravity * delta
	
	camera()
	
	if is_alive && is_playing:
		move_and_slide()
		logic()
		movement()

#game logic _______________________________________________________________________________________________

func logic() -> void:
	var hearts = ""
	for i in lifes:
		hearts += "♥"
	$HUD/HP_bar.text = str(hearts)
	if lifes <= 0:
		game_over()

#SUB-FUNCTIONS for game logic
func game_over() -> void:
	$"death_screen".show()
	is_alive = false
	is_playing = false
	print("gay over")

func win() -> void:
	is_playing = false
	$"victory_screen".show()

func camera() -> void:
	if Input.is_action_just_pressed("camera_zoom_in"):
		print("zoom in")
		$"Camera2D".zoom.x += 0.5
		$"Camera2D".zoom.y += 0.5
	if Input.is_action_just_pressed("camera_zoom_out"):
		print("zoom out")
		$"Camera2D".zoom.x -= 0.5
		$"Camera2D".zoom.y -= 0.5	

#character movement _______________________________________________________________________________________________

func movement() -> void: 	# handles all movement functions by waiting for inputs (declared below) [walk, jump, dash, climb]	
#if staying still, play idle animation
	if velocity.x == 0 && velocity.y == 0:	
		idle()
	
#walking with left and right
	walk()
	
#Handle Jump and Double Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || is_climbing	:
			anim_state_machine.travel("jump_start")
			jump()
		elif !double_jumped:             #allows for one double jump
			anim_state_machine.travel("jump_start 2")
			jump()
			double_jumped = true
	#resets double jump
	if double_jumped && (is_on_floor() || is_climbing):
		double_jumped = false
	
#Handle Dashing
	if Input.is_action_just_pressed("dash") && !is_dashing && !is_climbing: #maybe to add dash cooldown 
		dash()
	#resets movement after dash
	elif is_dashing:
		dash_reset()	#to reset movement after dash
	
#start climbing / attach to the wall
	if Input.is_action_pressed("climb") && is_on_wall():
		is_climbing = true
#Handles climbing
	if is_climbing:
		climb()
#RESET PLAYER POSITION, JUST IN CASE
	if Input.is_action_just_pressed("reset_position"):		#reset respawn mech add button
		reset_position()

#SUB-FUNCTIONS for movement
func idle() -> void: 	   #idle animation
	anim_state_machine.travel("idle")
	
func walk() -> void:	#handles Walking and IDLE
	var direction = Input.get_axis("left", "right")
	if direction == -1:
		$Sprite2D.flip_h = true
	elif direction == 1:
		$Sprite2D.flip_h = false
		
	if direction && !is_climbing && !is_dashing:	#locked during climb and dash
		velocity.x = direction * SPEED
		if is_on_floor():
			anim_state_machine.travel("run")
	else:	#slowing down after releasing
		velocity.x = move_toward(velocity.x, 0, 50)     
		if abs(velocity.x) > 0 && is_on_floor():
			anim_state_machine.travel("run_stop")

func jump() -> void:
	velocity.y = JUMP_VELOCITY
	
func climb() -> void:	
#climb up and down			
	anim.play("RESET")
	var climb_direction = Input.get_axis("up", "down")		
	if climb_direction:
		velocity.y = climb_direction * CLIMBING_SPEED
	else:	#slowing down after releasing
		velocity.y = 0
#
# Handle climb-jump
	if Input.is_action_just_pressed("jump"):	#should jump to the direction opposite of the wall
		jump()
		is_climbing = false
		
#stop climbing, any moment that you aren't touching the wall	
	if !is_on_wall():		#kinda fucks when on top
		print("too far from wall")
		is_climbing = false

func dash() -> void:	#to add to facing direction
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

func dash_reset() -> void:
	if prev_pos == position.x: #check if dash has been interrupted
		remaining_dashing=0;
		is_dashing = false
		print("dash reset")	
	else:
		prev_pos = position.x; #spomni kje je bilposizione v frame 1	(10)
	#waiting for dash to finish	
		if remaining_dashing > 0:
			remaining_dashing -= 1 #waits for  ${DASH_DURATION} (30) cicles to let you move again (reset your speed)
		else:
			is_dashing = false
			print("dash reset")

func reset_position() -> void:
		position.x = 550
		position.y = 400

#world interaction and life management _______________________________________________________________________________________________
func _on_node_2d_damaged() -> void:
	lifes -= 1 

func _on_ronda_touched(value) -> void:
	lifes -= value

func _on_node_2d_win(score: int) -> void:
	win()
