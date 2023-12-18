extends Node2D

@onready var lever_area: Area2D = $lever_area
@onready var popup_text: Label = $lever_area/popup_text

@export var affected_body: Node
@export var togglable: bool #if one shot or togglable lever

var is_interactable: bool = true

signal interact()

@onready var indicator: Label = $popup_text	 #can be changed to a visual effect or a light or whatever

func _ready() -> void:
	indicator.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if lever_area.get_overlapping_areas().any( func(area: Area2D) -> bool: return area.name == "player_area" ):
			print("player pulls the lever")
			if affected_body != null:
				affected_body.set_process(true)
			interact.emit()
			if !togglable:
				indicator.hide()
				is_interactable = false

func _on_lever_area_body_entered(body: StaticBody2D) -> void:
	print(body)
	if body.name == "player" && is_interactable:
		indicator.show()


func _on_lever_area_body_exited(body: StaticBody2D) -> void:
	if body.name == "player":
		indicator.hide()
