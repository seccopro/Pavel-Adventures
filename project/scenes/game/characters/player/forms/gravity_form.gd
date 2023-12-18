class_name gravity_form extends Form

@onready var masks = $"../../Sprite2D/CanvasGroup/masks"

func on_enter() -> void:
	if !masks.visible:
		masks.visible = !masks.visible
	masks.frame = 3
	pass

func form_process(delta: float) -> void:
	pass

func form_input(event: InputEvent) -> void:
	pass

func on_exit() -> void:
	pass
