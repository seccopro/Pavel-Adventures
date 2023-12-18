extends Node2D

@onready var anim:AnimationPlayer = $AnimationPlayer

func _on_lever_area_animation() -> void:
	anim.play("activation")
