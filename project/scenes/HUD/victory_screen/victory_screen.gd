extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_replay_pressed():
	get_tree().change_scene_to_file("res://scenes/_debug/movement_test.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
