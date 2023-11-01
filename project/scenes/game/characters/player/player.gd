extends CharacterBody2D

@onready var state_machine : CharacterStateMachine = $"CharacterStateMachine"
@onready var anim = $AnimationPlayer

@export var lifes : int = 3

var can_fall = true
var is_playing = true
var facing_right = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(delta):		#"MAIN" runs every delta time - CALLS ALL OTHER FUNCTIONS
	# Add the gravity.
	if (not is_on_floor() and can_fall):	#gravity / falling
		velocity.y += gravity * delta
	
	if(is_playing):
		#and activate physics
		move_and_slide()
	#camera controlling, zoom
	camera()
	animations()
	game_logic()
	

func camera():
	if(Input.is_action_just_pressed("camera_zoom_in")):
		$"Camera2D".zoom.x += 0.5
		$"Camera2D".zoom.y += 0.5
	if(Input.is_action_just_pressed("camera_zoom_out")):
		$"Camera2D".zoom.x -= 0.5
		$"Camera2D".zoom.y -= 0.5	


func animations():
	if(facing_right):
		$character_sprite.flip_h = false
	else:
		$character_sprite.flip_h = true







func game_logic():
	var hearts = ""
	for i in lifes:
		hearts += "♥"
	$HUD/HP_bar.text = str(hearts)
	if(lifes <= 0):
		death()

func win():
	is_playing = false
	$HUD/victory_screen.show()

func death():
	$CharacterStateMachine.current_state.next_state = $CharacterStateMachine.current_state.dead_state
	is_playing = false
	$HUD/death_screen.show()

func _on_node_2d_damaged():
	lifes -= 1 

func _on_ronda_touched(value):
	lifes -= value

func _on_node_2d_win(score):
	win()