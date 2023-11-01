extends Node2D

var lethal_depth= 600
signal damaged()
signal win(score)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	game_logic()


func game_logic():		#move in level
	if($player.position.y >= lethal_depth):		#falled
		emit_signal("damaged")
		reset_position()
	if( $player.position.y <= -50 ):
		print("you won!!!")
		emit_signal("win", 0)

func reset_position():
		$player.position.x = 550
		$player.position.y = 400



func _on_win_check_body_entered(body):
	if(body.name =="player"):
		emit_signal("win", 0)
