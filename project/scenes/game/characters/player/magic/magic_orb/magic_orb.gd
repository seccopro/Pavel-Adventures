extends Area2D

var starting_position 
var height 
var travel_distance = 300    
var final_position
var shoot_speed = 5
var facing_right


# Called when the node enters the scene tree for the first time.
func _ready():
	height = global_position.y 
	starting_position = global_position.x
	
	facing_right = get_parent().facing_right
	if facing_right:
		final_position = starting_position + travel_distance
	else:
		final_position = starting_position - travel_distance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.y = height        #holds y position
	#IS CHASING PLAYER MOVEMENT, maybe shouldn't be a player's child,but a level child?
	if(facing_right):                                                    #shoots right
		if ( global_position.x < final_position ):
			global_position.x +=  shoot_speed        #projectile speed
		else:
			queue_free()
	else:
		if ( global_position.x > final_position ):
			global_position.x -=  shoot_speed        #projectile speed
		else:
			queue_free()


func _on_body_entered(body):
	if(body.name != "player"):
		queue_free()
