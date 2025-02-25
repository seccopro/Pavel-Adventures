class_name Handoff
extends Area2D

signal player_entered_area(handoff: Handoff, transition_type: Scenes.GameSceneTransition)

@export_enum("north", "east", "south", "west") var entry_direction: String
@export var push_distance: int = 16
@export var next_scene: Scenes.GameScenes
@export var entry_handoff_name: String
@export var transition_type: Scenes.GameSceneTransition

func _ready() -> void:
	self.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	player_entered_area.emit(self, transition_type, body.direction)
	queue_free()

func get_player_entry_vector() -> Vector2:
	var vector: Vector2 = Vector2.LEFT
	match entry_direction:
		0: vector = Vector2.UP
		1: vector = Vector2.RIGHT
		2: vector = Vector2.DOWN
	return (vector * push_distance) + self.position

func get_move_dir() -> Vector2:
	var dir: Vector2 = Vector2.RIGHT
	match entry_direction:
		0: dir = Vector2.DOWN
		1: dir = Vector2.LEFT
		2: dir = Vector2.RIGHT
	return dir
