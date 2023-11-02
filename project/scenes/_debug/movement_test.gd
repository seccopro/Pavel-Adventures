extends Node2D

var lethal_depth = 600
signal damaged()
signal win(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_logic()

func game_logic() -> void:		#move in level
	if $player.position.y >= lethal_depth:		#falled
		emit_signal("damaged")
		reset_position()
	if $player.position.y <= -50:
		print("you won!!!")
		emit_signal("win", 0)

func reset_position() -> void:
		$player.position.x = 550
		$player.position.y = 400

func _on_win_check_body_entered(body: PhysicsBody2D) -> void:
	if body.name =="player":
		emit_signal("win", 0)
