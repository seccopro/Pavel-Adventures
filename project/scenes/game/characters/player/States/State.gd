class_name State extends Node

#("Character States")
var idle_state : State
var walking_state : State
var air_state : State
var dashing_state : State
var climbing_state : State
var casting_state : State
var dead_state : State

var player
var input_check
var animation_tree


@export_group("Behaviour Flags")
@export var can_move: bool = true
@export var can_fall: bool = true
@export var can_dash: bool = true
@export var can_jump: bool = true
@export var can_double_jump: bool = true
@export var can_wall_jump: bool = true
@export var can_climb: bool = true
@export var can_cast: bool = true
@export var can_change_form: bool = true

var character: CharacterBody2D
var next_state: State
var controls: Dictionary
var form_sm : FormStateMachine

func on_enter() -> void:
	pass

func state_process(delta: float) -> void:
	pass

func state_input(event: InputEvent) -> void:
	pass

func on_exit() -> void:
	pass
