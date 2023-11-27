class_name Ronda extends CharacterBody2D

const SPEED: float = 200.0
const JUMP_VELOCITY: float = -300.0

const target_range: Array[int] = [2000, 2400]
var target_position: int = 1

var is_okay: bool = true

signal touched(value)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta) -> void:
	# Add the gravity.
	move_and_slide()

	if !is_on_floor():
		velocity.y += gravity * delta

	if is_okay:
		range_walking()

func walk_right() -> void:
	velocity.x = SPEED
	
func walk_left() -> void:
	velocity.x = -SPEED

func stop_walking() -> void:
	velocity.x = 0
	
func range_walking() -> void:
	$"global_position_label".text = str(global_position.x)
	if target_position == 1:
		if global_position.x < target_range[1]:	#
			walk_right()
		else:
			target_position = 0	
	elif target_position == 0:
		if global_position.x > target_range[0]:
			walk_left()
		else:
			target_position = 1

func _on_event_detector_body_entered(body) -> void:
	if body.name == "player":
		velocity.y += JUMP_VELOCITY

func _on_damage_area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index) -> void:
	print("hit by a " + area.name)

	match area.name:	 #lose 2 health
		"magic_blast":
			die()
		"magic_orb":	#lose 1 health
			die() 
		"dark blast":	#lose 5 health
			die()

func die():
	print("ronda dead")
	queue_free() #lose 1 health
