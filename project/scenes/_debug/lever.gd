extends Node2D

@onready var lever_area = $lever_area
@export var affected_body: Node
@export var togglable: bool #if one shot or togglable lever
var is_interactable = true

signal interact()

# Called when the node enters the scene tree for the first time.
func _ready():
	$popup_text.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if lever_area.get_overlapping_areas().any( func(area): return area.name == "player_area" ):
			print("player pulls the lever")
			affected_body.set_process(true)
			interact.emit()
			if !togglable:
				is_interactable = false


func _on_lever_area_body_entered(body):
	if is_interactable:
		if body.name == "player" && is_interactable:
			$popup_text.show()


func _on_lever_area_body_exited(body):
	if body.name == "player":
		$popup_text.hide()
