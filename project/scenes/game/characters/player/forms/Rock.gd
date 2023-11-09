class_name rock_form extends Form

func on_enter() -> void:
	print("rock form equipped")
	#animations

func form_process(delta: float) -> void:
	pass

func form_input(event: InputEvent) -> void:
	pass

func on_exit() -> void:
	#animation
	print("out of no form")
	pass
