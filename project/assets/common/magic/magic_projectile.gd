extends Node

@onready var this: Node = $"."

@export var travel_distance: float = 200
@export var shoot_speed: float = 500.0

var first_time: bool = true
var starting_position: float
var final_position: float
var is_facing_right: bool = true #gets defined by parent



func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if first_time:
		first_time = false
		starting_position = this.global_position.x
		
		if is_facing_right:
			final_position = starting_position + travel_distance
		else:
			final_position = starting_position - travel_distance
	
	
	
	if is_facing_right:                              #shoots right
		if this.global_position.x < final_position:
			this.global_position.x +=  shoot_speed * delta      #projectile speed
		else:
			queue_free()
	else:
		if this.global_position.x > final_position:
			this.global_position.x -=  shoot_speed * delta       #projectile speed
		else:
			queue_free()

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.name != "player":
		queue_free()
