class_name AirState extends State

var has_double_jumped: bool = false

func on_enter() -> void:
	pass

func state_input(event: InputEvent) -> void: 
	
	if Input.is_action_just_pressed("jump"):	#double jump
		if !has_double_jumped:
			double_jump()
	
	$"../input_check".permission_checker($".", event)	#main state changer

func state_process(delta: float) -> void:
	if can_move:
		movement()		#instead of walking state
	
	#change state
	if character.is_on_floor():
		if character.velocity.x == 0:
			next_state = idle_state			#TO IDLE STATE
		else:
			next_state = walking_state		#TO WALKING STATE
	
	if Input.is_action_pressed("climb") && character.is_on_wall() && !get_parent().just_detached:	#TO CLIMBING STATE
		next_state = climbing_state

func movement() -> void:
	var direction: float = Input.get_axis("left", "right")
	if direction:
		character.velocity.x = direction * get_parent().MOVING_SPEED	
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, 50)	

func double_jump() -> void:
	character.velocity.y = get_parent().DOUBLE_JUMP_VELOCITY
	has_double_jumped = true
	
func on_exit() -> void:
	if next_state == idle_state || next_state == walking_state:	#reset double jump
		has_double_jumped = false
