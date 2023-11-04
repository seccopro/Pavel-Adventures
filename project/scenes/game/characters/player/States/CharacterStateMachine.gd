class_name CharacterStateMachine extends Node

@export var character : CharacterBody2D
@export var current_state : State

@onready var controls : Dictionary  = $"../controls".controls

@export_group("Character Movement")
@export var WALKING_SPEED: float = 300
@export var MOVING_SPEED : float = 300
@export var JUMP_VELOCITY : float = -400
@export var DOUBLE_JUMP_VELOCITY : float = -400
@export var DASH_VELOCITY: float = 800

var just_detached: bool = false

func _ready() -> void:
	for child in get_children():
		child.controls = controls
		if !(child is State):
			if child == $input_check:
				print("started input_check")
			else:
				print("child isn't a state: " + str(child))
			return
		
		child.character = character		
		print("appended state: " + str(child))

func _physics_process(delta: float) -> void:	
	#PICKS STATE
	if current_state.next_state != null:
		switch_states(current_state.next_state)
		
	#RUNS STATE
	current_state.state_process(delta)
	get_parent().can_fall = current_state.can_fall		#applies gravity to states that can fall

func switch_states(new_state: State) -> void:
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	current_state.on_enter()

#called on input events (like interrupt)
func _input(event:InputEvent) -> void:
	current_state.state_input(event)
