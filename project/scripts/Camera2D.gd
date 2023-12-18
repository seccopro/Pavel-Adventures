extends Camera2D

@export var player: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(player)
	if player == null:
		print("assign the player to this camera")
		print(self)
		#throw error


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = player.position	#follow the player

