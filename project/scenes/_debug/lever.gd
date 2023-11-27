extends Node2D

@onready var lever_area = $lever_area
@export var victim: Node

signal interact()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if lever_area.get_overlapping_areas().any( func(area): return area.name == "player_area" ):
			print("player pulls the lever")
			interact.emit()
