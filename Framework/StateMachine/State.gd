class_name State
extends Node

signal transition_to(current_state: State, next_state: String, msg: Dictionary)

var player: Player

func _ready() -> void:
	await owner.ready
	
	player = owner as Player
	assert(player != null)

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
