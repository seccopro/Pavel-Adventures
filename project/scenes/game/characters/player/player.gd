extends CharacterBody2D

@export var player_config: Node
@export var lifes : int = 3
@export var level: Node


@onready var state_machine : CharacterStateMachine = $"CharacterStateMachine"

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
		move_and_slide()
		raycasts()
		#camera()	deactivated, can be used for animation debug (zoom in and out)
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

func camera() -> void:		#deactivated, can be used for animation debug (zoom in and out)
	if Input.is_action_just_pressed("camera_zoom_in"):
		print("zoom in")
		$"Camera2D".zoom.x += 0.5
		$"Camera2D".zoom.y += 0.5
	if Input.is_action_just_pressed("camera_zoom_out"):
		print("zoom out")
		$"Camera2D".zoom.x -= 0.5
		$"Camera2D".zoom.y -= 0.5	

func animations() -> void:
	if is_facing_right: 
		
		$Sprite2D.set_scale(Vector2(1, 1))
	else:
		
		$Sprite2D.set_scale(Vector2(-1, 1))

func game_logic() -> void:
	var hearts: String = ""
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




func _on_node_2d_win(score: int) -> void:
	win()


func _on_damage_area_area_entered(area: Area2D) -> void:
	#print(area.name)
	match area.name:	 #lose 2 health
		"spike_damage_area":	#layer 3 is trap layer
			lifes -= 1 #area.damage
			print("!! - damaged on spikes")
			#velocity = -velocity  #kek bouncy spikeys
			if velocity.y > 0:
				velocity.y = -player_config.spikes_bounce
			else:
				if velocity.x > 0:
					velocity.x -= player_config.spikes_knockback
				else:
					velocity.x = player_config.spikes_knockback
		
		"ronda_damage_area":				#layer 4 is enemies layer
			lifes -= 1
			print("!! Ronda hurts!")
			if velocity.x > 0:
				velocity.x -= player_config.ronda_knockback
			else:
				velocity.x = player_config.ronda_knockback
		
		"heavy_object":	#lose 5 health
			lifes -= 1
	#default
		_:
			#print("player hit " + area.name)
			pass
