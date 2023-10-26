extends Node2D

var lethal_depth= 600
var lifes = 3		#should get them and send to player (or just get and set methods from player)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	game_logic()


func game_logic():		#move in level
	if( lifes <=0 ):
		game_over()
	if($player.position.y >= lethal_depth):
		lifes -= 1
		print("only " + str(lifes) + " lifes left")
		reset_position()
	if($player.position.x>= 2900 or $player.position.y <= -50):
		print("you won!!!")

func reset_position():
		$player.position.x = 550
		$player.position.y = 400

func game_over():
		print("gay over")
		get_tree().change_scene_to_file("res://scenes/menu/main-menu.tscn")
		
