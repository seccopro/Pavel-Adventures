extends Node2D

var lethal_depth= 600
signal damaged()
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
	if($player.position.x>= 2900 or $player.position.y <= -50):
		print("you won!!!")

func reset_position():
		$player.position.x = 550
		$player.position.y = 400

