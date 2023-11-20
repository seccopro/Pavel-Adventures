class_name CastingState extends State

@onready var magic_handler = $magic_handler

var time_elapsed : float = 0.0

func on_enter() -> void:
	character.velocity.y = 0
	character.velocity.x = 0

func state_input(event: InputEvent) -> void:
	input_check.permission_checker($".", event)

func state_process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= magic_handler.cast_duration:
		next_state = magic_handler.previous_state

func on_exit() -> void:
	time_elapsed = 0
