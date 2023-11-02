extends Area2D

var starting_position: float
var height: float
var travel_distance: float = 300.0	
var final_position: float
var shoot_speed: float = 5
var is_facing_right: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	height = global_position.y 
	starting_position = global_position.x
	
	is_facing_right = get_parent().is_facing_right
	if is_facing_right:
		final_position = starting_position + travel_distance
	else:
		final_position = starting_position - travel_distance
	final_position = starting_position + travel_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y = height		#holds y position
	if is_facing_right:                                                    #shoots right
		if global_position.x < final_position:
			global_position.x +=  shoot_speed        #projectile speed
		else:
			queue_free()
	else:
		if global_position.x > final_position:
			global_position.x -=  shoot_speed        #projectile speed
		else:
			queue_free()

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.name != "player":
		queue_free()
