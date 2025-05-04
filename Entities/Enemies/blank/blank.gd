class_name Blank extends CharacterBody2D

const SPEED: float = 100.0
const CHASING_SPEED: float = 200.0

var is_okay: bool = true

@export
var range_radius: float

var home_position: Vector2
var target_position: Vector2

var wait_timer: float = 0.0
const WAIT_TIME: float = 1.0

var direction_r : bool = true;
var direction_up : bool = true;

var berserk: bool = false;
var detected_body : CharacterBody2D = null



func _ready() -> void:
	#randomize()
	home_position = global_position
	pick_new_target()
	$sound/idle.play()
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	if is_okay:
		if berserk:
			chase()
		else:
			range_hovering()
	
	
func range_hovering() -> void:
	#write the code here chatgpt
	if !$sound/idle.playing:
		$sound/idle.play()
	
	var to_target = target_position - global_position

	if to_target.length() < 10.0:
		wait_timer = WAIT_TIME
		pick_new_target()
	else:
		velocity = to_target.normalized() * SPEED


func pick_new_target() -> void:
	var angle = randf() * TAU  # 0 to 2*PI
	var radius = randf() * range_radius
	var offset = Vector2(cos(angle), sin(angle)) * radius
	target_position = home_position + offset



func chase() -> void:
	direction_r = (detected_body.global_position.x > global_position.x)
	if(direction_r):
		velocity.x = CHASING_SPEED
	else:
		velocity.x = -CHASING_SPEED
		
	direction_up = (detected_body.global_position.y > global_position.y)
	if(direction_up):
		velocity.y = CHASING_SPEED
	else:
		velocity.y = -CHASING_SPEED


func _on_player_seeker_body_entered(body: Node2D) -> void:
		if body.name == "Player":
			$sound/idle.stop()
			$sound/swoop.play()
			print("blank detected a player; " + body.name)
			print("blank went full berserk mode")
			detected_body = body
			berserk = true
