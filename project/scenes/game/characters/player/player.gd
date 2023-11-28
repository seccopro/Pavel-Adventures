extends CharacterBody2D

@onready var state_machine : CharacterStateMachine = $"CharacterStateMachine"

@export var lifes : int = 3

var can_fall: bool = true
var is_playing: bool = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_flip_sprite: bool = true

var is_facing_right : bool = true
var is_looking_up : bool = false
var is_looking_down : bool = false

var is_on_ground : bool = false
var is_on_wall_r : bool = false
var is_on_wall_l : bool = false

var has_mask_rock : bool = true
var has_mask_fire : bool = true
var has_mask_gravity : bool = true
var has_mask_ice : bool = true

func _input(event:InputEvent) -> void:
	#looking up and down logic	-PROBABLY SHOULDN'T BE HERE
	if(Input.is_action_just_pressed("up")):
		is_looking_up = true
	if(Input.is_action_just_pressed("down")):
		is_looking_down = true
	if(Input.is_action_just_released("up")):
		is_looking_up = false
	if(Input.is_action_just_released("down")):
		is_looking_down = false

func _physics_process(delta: float) -> void:		#"MAIN" runs every delta time - CALLS ALL OTHER FUNCTIONS
	if !is_on_ground && can_fall:	#gravity / falling
		velocity.y += gravity * delta
	
	if is_playing:
		#and activate physics
		move_and_slide()
		raycasts()
		#camera()
		animations()
		game_logic()

func raycasts() -> void:
	if $floor_checker.is_colliding():
		is_on_ground = true
	else:
		is_on_ground = false
		
	if $left_wall_checker.is_colliding():
		is_on_wall_l = true
	else:
		is_on_wall_l = false
		
	if $right_wall_checker.is_colliding():
		is_on_wall_r = true
	else:
		is_on_wall_r = false

func camera() -> void:
	if Input.is_action_just_pressed("camera_zoom_in"):
		print("zoom in")
		$"Camera2D".zoom.x += 0.5
		$"Camera2D".zoom.y += 0.5
	if Input.is_action_just_pressed("camera_zoom_out"):
		print("zoom out")
		$"Camera2D".zoom.x -= 0.5
		$"Camera2D".zoom.y -= 0.5	

func animations():
	if is_facing_right: 
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func _on_node_2d_damaged() -> void:
	lifes -= 1 

func _on_ronda_touched(value: int) -> void:
	lifes -= value

func _on_node_2d_win(score: int) -> void:
	win()

func game_logic() -> void:
	var hearts = ""
	for i in lifes:
		hearts += "♥"
	$HUD/HP_bar.text = str(hearts)
	if lifes <= 0:
		death()

func win() -> void:
	is_playing = false
	$HUD/victory_screen.show()

func death() -> void:
	$CharacterStateMachine.current_state.next_state = $CharacterStateMachine.current_state.dead_state
	is_playing = false
	$HUD/death_screen.show()


func _on_damage_area_area_entered(area):
	match area.name:	 #lose 2 health
		"spike_damage_area":
			lifes -= 1 #area.damage
			print("!! - damaged on spikes")
			#velocity = -velocity  #kek bouncy spikeys
			if velocity.y > 0:
				velocity.y = -1000
			else:
				if velocity.x > 0:
					velocity.x -= 1500 
				else:
					velocity.x = 1000
		
		"ronda_damage_area":	#lose 1 health
			lifes -= 1
			print("!! Ronda hurts!")
			if velocity.x > 0:
				velocity.x -= 1500 
			else:
				velocity.x = 1000
		
		"heavy_object":	#lose 5 health
			lifes -= 1
			
		_:		#default
			print("player hit " + area.name)
			
#	if area.name == "spike_damage_area":
#		lifes -= 1 #area.damage
#		print("!! - damaged on spikes")
#		#velocity = -velocity  #kek bouncy spikeys
#		if velocity.y > 0:
#			velocity.y = -1000
#		else:
#			if velocity.x > 0:
#				velocity.x -= 1500 
#			else:
#				velocity.x = 1000
#	elif area.name == "ronda_damage_area":
#		lifes -= 1
#		print("!! Ronda hurts!")
#		if velocity.x > 0:
#			velocity.x -= 1500 
#		else:
#			velocity.x = 1000
#	else:
#		print("player hit" + area.name)
#
	
