class_name PlayerCamera
extends Camera2D

@export_category("Settings")
@export var smoothing: bool
@export_range(1, 10) var smoothing_distance: int = 8

@onready var player: Player = %Player
@onready var weight: float = float(11 - smoothing_distance) / 100.0

func _ready() -> void:
	if player == null:
		push_error("No player in scene: [%s]" % get_tree().root.name)

func _physics_process(delta: float) -> void:
	var camera_position: Vector2
	player.global_position
	if smoothing == true:
		camera_position = lerp(global_position, player.global_position, weight)
	else:
		camera_position = player.global_position
	
	global_position = camera_position.floor()
