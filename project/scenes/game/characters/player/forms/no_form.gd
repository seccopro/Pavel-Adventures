class_name nMGRo_form extends Form

func on_enter() -> void:
	$"../../Sprite2D/masks".visible = !$"../../Sprite2D/masks".visible
	print("no form equipped")
	#animation

func form_process(delta: float) -> void:
	pass

func form_input(event: InputEvent) -> void:
	pass

func on_exit() -> void:
	#animation
	print("out of no form")
	pass
