extends Area2D

var offset_x : float = 50
var offset_y : float = 100
var time_elapsed : float = 0.0
var duration : float = 0.2 #seconds
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(get_parent().is_looking_up):#aiming up
		position += Vector2(0, -offset_y)
	elif(get_parent().is_looking_down):#aiming down
		position += Vector2(0, offset_y)
	elif(get_parent().is_facing_right):	#aiming right
		position += Vector2(offset_x, 0)
	else:#aiming left or "weird?"
		position += Vector2(-offset_x, 0)

func _process(delta: float) -> void:	
	time_elapsed += delta
	if(time_elapsed >= duration):
		queue_free()
