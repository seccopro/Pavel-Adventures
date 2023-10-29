extends Node

class_name State

@export var idle_state : State
@export var walking_state : State
@export var air_state : State
@export var dashing_state : State
@export var climbing_state : State
@export var casting_state : State


@export var can_move : bool = true
@export var can_fall : bool = true
@export var can_dash : bool = true
@export var can_jump : bool = true
@export var can_cast : bool = true

var character : CharacterBody2D
var next_state : State

func state_process(delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
