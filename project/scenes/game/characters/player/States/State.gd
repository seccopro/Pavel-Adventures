class_name State extends Node

@export_group("Character States")
@export var idle_state : State
@export var walking_state : State
@export var air_state : State
@export var dashing_state : State
@export var climbing_state : State
@export var casting_state : State
@export var dead_state : State

@export_group("Behaviour Flags")
@export var can_move: bool = true
@export var can_fall: bool = true
@export var can_dash: bool = true
@export var can_jump: bool = true
@export var can_climb: bool = true
@export var can_cast: bool = true

var character: CharacterBody2D
var next_state: State
var controls: Dictionary

func on_enter() -> void:
	pass

func state_process(delta: float) -> void:
	pass

func state_input(event: InputEvent) -> void:
	pass

func on_exit() -> void:
	pass
