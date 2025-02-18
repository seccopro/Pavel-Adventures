class_name StateIdle
extends State

func enter(previous_state: State, msg: Dictionary = {}) -> void:
	player.animation_tree.set("parameters/ground_air/transition_request", "movement")
	player.animation_tree.set("parameters/movement/transition_request", "idle")

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, delta)
	
	if !player.is_on_floor:
		transition_to.emit(self, "air")
