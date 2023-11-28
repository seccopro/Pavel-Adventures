extends Node2D

@onready var rb: RigidBody2D = $weight_rigidbody
@onready var damaging_area: CollisionShape2D = $weight_rigidbody/heavy_object/weight_shape

@export var rope_to_delete: Sprite2D 
@export var weight_sprite: Sprite2D

var is_falling = false
var time_elapsed: float = 0.0

var first_time:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	damaging_area.disabled = true
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first_time:
		time_elapsed = 0.0
		is_falling = true
		rb.freeze = false
		if rope_to_delete != null:
			rope_to_delete.queue_free()
		first_time = false
	
	#weight_sprite follows the rigidbody
	weight_sprite.position = rb.position
	weight_sprite.rotation = rb.rotation
	
	if is_falling:
		time_elapsed += delta
		if rb.linear_velocity.y > 50:
			damaging_area.disabled = false
		elif time_elapsed >= .2 :		#if after 1 sec speed is lower than 100p/s, stop falling
			damaging_area.disabled = true
			is_falling = false

