extends Node2D

@onready var lever_area: Area2D = $area

@export var affected_body: Node
@export var single_use: bool #if one shot or togglable lever
@export var is_interactable: bool = true

signal interact()
signal animation()

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && is_interactable:
		if lever_area.get_overlapping_areas().any( func(area: Area2D) -> bool: return area.name == "player_area" ):
			print("player pulls the lever")
			if affected_body != null:
				affected_body.set_process(true)
			interact.emit()
			animation.emit()
			if single_use:
				is_interactable = false

