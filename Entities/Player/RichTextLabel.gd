class_name DebugLabel
extends Label

@onready var state_machine: StateMachine = %FSM_movement

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "State: %s" % state_machine.active_state.name
