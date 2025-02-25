class_name State
extends Node

signal transition_to(current_state: State, next_state: String, msg: Dictionary)

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func unhandled_input(event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
