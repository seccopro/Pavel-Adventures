class_name Level
extends Node2D

@export var player: Player
@export var handoffs: Array[Handoff]

var data: LevelDataHandoff

func _ready() -> void:
	player.disable()
	player.visible = false
	
	if data == null:
		init_scene()
		start_scene()

func get_data() -> LevelDataHandoff:
	return data

func set_data(new_data: LevelDataHandoff) -> void:
	data = new_data

func init_scene() -> void:
	init_player_location()

func start_scene() -> void:
	player.enable()
	connect_to_handoffs()

func init_player_location() -> void:
	player.visible = true
	if data != null:
		for handoff in handoffs:
			if handoff.name == data.entry_handoff_name:
				player.position = handoff.get_player_entry_vector()
		player.orient(data.move_dir)

func on_player_handoff_area_reached(handoff: Handoff, transition_type: Scenes.GameSceneTransition) -> void:
	disconnect_from_handoffs()
	player.disable()
	player.queue_free()
	
	data = LevelDataHandoff.new()
	data.entry_handoff_name = handoff.entry_handoff_name
	data.move_dir = handoff.get_move_dir()
	set_process(false)
	
	SignalBus.next_scene_requested.emit(handoff, transition_type)

func connect_to_handoffs() -> void:
	for handoff in handoffs:
		if not handoff.player_entered_area.is_connected(on_player_handoff_area_reached):
			handoff.player_entered_area.connect(on_player_handoff_area_reached)

func disconnect_from_handoffs() -> void:
	for handoff in handoffs:
		if handoff.player_entered_area.is_connected(on_player_handoff_area_reached):
			handoff.player_entered_area.connect(on_player_handoff_area_reached)
