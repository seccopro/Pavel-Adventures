class_name CharacterStateMachine extends Node

@export_group("Essential stuff")
@export var character : CharacterBody2D
@export var form_sm : FormStateMachine

@export_group("Character States")
@export var idle_state: State
@export var walking_state: State
@export var air_state: State
@export var attack_state: State
@export var dashing_state: State
@export var climbing_state: State
@export var casting_state: State
@export var dead_state: State
var current_state: State
var previous_state: State


@onready var controls : Dictionary  = $"../controls".controls
@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var player = $".."
@onready var input_check = $input_check


var just_detached: bool = false

func _ready() -> void:
	for child in get_children():
		child.controls = controls
		if !(child is State):
			if child == input_check:
				print("started input_check")
			else:
				print("child isn't a state: " + str(child))
			return
		
		#load states
		child.idle_state = idle_state
		child.walking_state = walking_state
		child.air_state = air_state
		child.attack_state = attack_state
		child.dashing_state = dashing_state
		child.climbing_state = climbing_state
		child.casting_state = casting_state
		child.dead_state = dead_state
		
		#load variables
		child.character = character		#character rigid body
		child.form_sm = form_sm
		child.player = player			#player script, for variables
		child.animation_tree = animation_tree
		child.input_check = input_check
		child.CSM = $"."
		child.variables = player.variables
		print("appended state: " + str(child))
		
		#starting state
		current_state = idle_state

func _physics_process(delta: float) -> void:	
	#CHANGES STATE
	if current_state.next_state != null:
		switch_states(current_state.next_state)
	
	#RUNS STATE
	current_state.state_process(delta)
	get_parent().can_fall = current_state.can_fall		#applies gravity to states that can fall

func switch_states(new_state: State) -> void:
	if current_state == null:
		return
	
	current_state.on_exit()
	current_state.next_state = null	
	
	current_state = new_state
	current_state.on_enter()

#called on input events (like interrupt)
func _input(event:InputEvent) -> void:
	current_state.state_input(event)
