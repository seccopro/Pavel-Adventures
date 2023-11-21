class_name ClimbingState extends State

@export var VERTICAL_SPEED :float = 700

func on_enter() -> void:
	can_fall = false
	if character.is_on_wall_r :
		character.is_facing_right  = true
	elif character.is_on_wall_l :
		character.is_facing_right = false
	
func state_process(delta: float) -> void:		
	vertical_movement()
	if ( !character.is_on_wall_l && !character.is_on_wall_r ): #handles detaching via being too far from wall	
		if character.velocity.y < 0: #jump on top of the wall			
			character.velocity.y += 100
			$jump_on_wall.start()	#go left or right after .1 sec
		else:
			print("fell from wall")
		
		next_state = air_state

func state_input(event : InputEvent) -> void:
	if Input.is_action_just_pressed(controls.climb):	#starts detaching
		$"climb_detach".start()
	if Input.is_action_just_released(controls.climb):	
		$"climb_detach".stop()		
	
	input_check.permission_checker($".", event)

func vertical_movement() -> void:
	var direction: float = Input.get_axis(controls.move_up, controls.move_down)
	if direction:
		character.velocity.y = direction * VERTICAL_SPEED	
	else:
		character.velocity.y = 0.0

func on_exit() -> void:
	$"climb_detach".stop()
	player.can_fall = true

func _on_climb_detach_timeout() -> void:	#TO IDLE STATE (OR AIR)
	player.just_detached = true
	$"just_detached".start()		#climbing cooldown
	next_state = idle_state	

func _on_just_detached_timeout():	#can re-attach
	player.just_detached = false


func _on_jump_on_wall_timeout():
	if character.is_facing_right :
		character.velocity.x = 400
	else:
		character.velocity.x = -400
