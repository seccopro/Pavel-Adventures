extends State

class_name ClimbingState

@export var VERTICAL_SPEED :float = 300

func on_enter():
	can_fall = false

func state_process(delta):
	if(not character.is_on_wall() and not character.is_on_floor()):	#to idle / air state by falling
		print("fell from wall")				#♂temporary solution, while on floor is not on wall
		next_state = air_state
	vertical_movement()
	

func state_input(event : InputEvent):
	if(Input.is_action_just_pressed("climb")):	#starts detaching
		$"climb_detach".start()
	if(Input.is_action_just_released("climb")):	
		$"climb_detach".stop()		
	
	$"../input_check".permission_checker($".", event)

func vertical_movement():
	var direction = Input.get_axis("up", "down")
	if direction:
		character.velocity.y = direction * VERTICAL_SPEED	
	else:
		character.velocity.y = 0

func on_exit():
	$"climb_detach".stop()
	get_parent().get_parent().can_fall = true


func _on_climb_detach_timeout():	#TO IDLE STATE (OR AIR)
	get_parent().just_detached = true
	$"just_detached".start()		#climbing cooldown
	next_state = idle_state	

func _on_just_detached_timeout():	#can re-attach
	get_parent().just_detached = false
