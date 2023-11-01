extends Control

func _on_start_pressed() -> void:
	print("start")

func _on_quit_pressed() -> void:
	print("quit")
	get_tree().quit()

func _on_training_pressed() -> void:
	print("training")
	get_tree().change_scene_to_file("res://scenes/_debug/movement_test.tscn")
