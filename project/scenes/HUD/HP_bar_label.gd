extends Label

@export var state_machine : CharacterStateMachine
@export var form_sm : FormStateMachine

func _process(delta: float) -> void:
	text= "State: " + state_machine.current_state.name + "\nForm: " + form_sm.current_form.name
