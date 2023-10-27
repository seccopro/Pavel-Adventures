extends CharacterBody2D


const SPEED = 200
const JUMP_VELOCITY = -300.0

const target_range = [1100, 2500]
var target_position = 1

var is_okay = true

signal touched(value)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	move_and_slide()
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_okay:
		range_walking()
	

func walk_right():
	velocity.x = SPEED
	
func walk_left():
	velocity.x = -SPEED

func stop_walking():
	velocity.x = 0
	
func range_walking():
	$"global_position_label".text = str(global_position.x)
	if( target_position == 1 ):
		if ( global_position.x < target_range[1]):	#
			walk_right()
		else:
			target_position = 0	
	elif(target_position == 0):
		if ( global_position.x > target_range[0]):
			walk_left()
		else:
			target_position = 1


func _on_event_detector_body_entered(body):
	print("ronda has detected a " + str(body))
	if(body.name == "player"):
		velocity.y += JUMP_VELOCITY


func _on_damage_area_body_entered(body):
	if(body.name == "player"):
		print("ronda has damaged you")
		emit_signal("touched", 1)
