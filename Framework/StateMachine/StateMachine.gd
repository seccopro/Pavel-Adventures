class_name StateMachine
extends Node

@export var initial_state: State
@onready var active_state: State = \
(func () -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

# TODO(primoz): state names to enum
var states: Dictionary = {}

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		states[state_node.name.to_lower()] = state_node
		state_node.transition_to.connect(on_state_transition_to)
	
	await owner.ready
	active_state.enter(null)

func _process(delta: float) -> void:
	assert(active_state != null)
	active_state.update(delta)

func _physics_process(delta: float) -> void:
	assert(active_state != null)
	active_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	assert(active_state != null)
	active_state.unhandled_input(event)

func on_state_transition_to(state: State, new_state_name: String, msg: Dictionary = {}) -> void:
	if state != active_state:
		push_warning("The state is already the active state: [%s]" % state.name.to_lower())
		return
	
	var new_state: State = states.get(new_state_name.to_lower())
	if new_state == null:
		push_error("Can't transition to an uknown state: [%s]" % new_state_name.to_lower())
		return
	
	assert(active_state != null)
	var previous_state: State = active_state
	
	active_state.exit()
	active_state = new_state
	active_state.enter(previous_state, msg)
	
