extends Node2D



@onready var door_area = $door_area


@export var next_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up"):
		if door_area.get_overlapping_areas().any( func(area): return area.name == "player_area" ):
			print("player walks trough the door")
			next_level()
			#change scene into next scene
			

func next_level():
	var ERR = get_tree().change_scene_to_packed(next_scene)
	
	if ERR != OK:
		print("Sum Tin Wong")
