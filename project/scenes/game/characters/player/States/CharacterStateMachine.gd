extends Node

class_name CharacterStateMachine 

@export var character : CharacterBody2D
@export var current_state : State

var states : Array[State]

func _ready():
	for child in get_children():
		if ( !(child is State) ):
			print( "child isn't a state: " + str(child) )
			return
		
		states.append(child)
		child.character = character
		print("appended state: " + str(child))

func _physics_process(delta):
	#PICKS STATE
	if( current_state.next_state != null):
		switch_states(current_state.next_state)
	#RUNS STATE
	current_state.state_process(delta)

func switch_states(new_state : State):
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	current_state.on_enter()

#called on input events (like interrupt)
func _input(event:InputEvent):
	current_state.state_input(event)

func can_move():
	return current_state.can_move
