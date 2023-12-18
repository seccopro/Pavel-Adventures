extends Node2D

@onready var weight_rb: RigidBody2D = $hanging_weight_rb
@onready var damaging_area: CollisionShape2D = $hanging_weight_rb/heavy_object/weight_shape
@onready var rope_to_delete: Sprite2D = $rope
@onready var weight_sprite: Sprite2D = $weight

@export var delete_rope: bool = true

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
		weight_rb.freeze = false
		if delete_rope:
			rope_to_delete.queue_free()
		first_time = false
	
	#weight_sprite follows the rigidbody
	weight_sprite.position = weight_rb.position
	weight_sprite.rotation = weight_rb.rotation
	
	if is_falling:
		time_elapsed += delta
		if weight_rb.linear_velocity.y > 50:
			damaging_area.disabled = false
		elif time_elapsed >= .2 :		#if after 1 sec speed is lower than 100p/s, stop falling
			damaging_area.disabled = true
			is_falling = false

