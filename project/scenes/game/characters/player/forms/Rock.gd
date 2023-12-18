class_name rock_form extends Form

@onready var masks = $"../../Sprite2D/CanvasGroup/masks"

func on_enter() -> void:
	if !masks.visible:
		masks.visible = !masks.visible
	masks.frame = 0
	#animations

func form_process(delta: float) -> void:
	pass

func form_input(event: InputEvent) -> void:
	pass

func on_exit() -> void:
	#animation
	print("out of no form")
	pass
