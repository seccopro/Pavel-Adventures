class_name Ronda extends CharacterBody2D

const SPEED: float = 200.0
const CHASING_SPEED: float = 400.0
const JUMP_VELOCITY: float = -300.0

var is_okay: bool = true

@onready
var will_fall_r = $movement_sensor/will_fall_r
@onready
var will_fall_l = $movement_sensor/will_fall_l
@onready
var wall_collide_r = $movement_sensor/wall_r
@onready
var wall_collide_l = $movement_sensor/wall_l

var direction_r : bool = true;

var berserk: bool = false;

var detected_body : CharacterBody2D = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	move_and_slide()

	if !is_on_floor():
		velocity.y += gravity * delta

	if is_okay:
		if berserk:
			chase()
		else:
			range_walking()

func range_walking() -> void:
	#walk untill cant -> swap direction
	if(direction_r):
		velocity.x = SPEED
	else:
		velocity.x = -SPEED

	if(direction_r):
		if(!will_fall_r.is_colliding() || wall_collide_r.is_colliding()):
			direction_r = !direction_r
	else:
		if(!will_fall_l.is_colliding() || wall_collide_l.is_colliding()):
			direction_r = !direction_r


func chase() -> void:
	direction_r = (detected_body.global_position.x > global_position.x)
	if(direction_r):
		velocity.x = CHASING_SPEED
	else:
		velocity.x = -CHASING_SPEED
	
#	if(detected_area.global_position.y < global_position.y):
#		velocity.y += JUMP_VELOCITY


func die() -> void:
	#print("ronda dead")
	$dead.play()
	#despawnjra skupi z zvokom
	queue_free() #lose 1 health

func _on_ronda_damage_area_area_entered(area : Area2D) -> void:
	print("ronda is hit by a " + area.name)
	match area.name:	 #lose 2 health
		"magic_blast":
			die()
		"magic_orb":	#lose 1 health
			die() 
		"dark blast":	#lose 5 health
			die()
		"heavy_object":	#die squished
			print("ronda spiaccicata")
			die()
		"spike_area":
			die()

func _on_self_awerness_zone_area_entered(area):
	if(area.name == "spike_area"):
		direction_r = !direction_r


func _on_player_seeker_body_entered(body: Node2D) -> void:
		if body.name == "Player":
			print("detected a player; " + body.name)
			print("full berserk mode on")
			detected_body = body
			berserk = true
