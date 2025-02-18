class_name GameManager
extends Node

@onready var scene_holder: Node2D = %SceneHolder
@onready var hud: Control = %HUD

@onready var scene_manager: SceneManager = preload("res://World/SceneManager/SceneManager.gd").new()

var current_scene: Node

func _ready() -> void:
	# TODO(primoz): load savefile
	SignalBus.request_next_scene.connect(on_request_next_scene)
	SignalBus.request_quit.connect(on_request_quit)
	
	scene_manager.loading_started.connect(on_loading_started)
	scene_manager.loading_completed.connect(on_loading_completed)
	scene_manager.scene_added.connect(on_scene_added)
	
	current_scene = scene_holder.get_child(0) as Node
	scene_manager.swap_scenes(Scenes.GameScenes.MainScene, scene_holder, current_scene, Scenes.GameSceneTransition.FadeFromBlack)

func _input(event: InputEvent) -> void:
	if current_scene == null:
		return
	
	if event.is_action_pressed("ui_cancel"):
		if current_scene is MainScreen:
			on_request_quit()
		else:
			scene_manager.swap_scenes(Scenes.GameScenes.MainScene, scene_holder, current_scene, Scenes.GameSceneTransition.FadeToBlack)

func on_loading_started(_loading_screen: LoadingScreen) -> void:
	pass

func on_loading_completed(level: Node) -> void:
	current_scene = level

func on_scene_added(_scene: Node, loading_screen: LoadingScreen) -> void:
	if loading_screen != null:
		var loading_parent: Node = loading_screen.get_parent() as Node
		loading_parent.move_child(loading_screen, loading_parent.get_child_count() - 1)
	
	move_child(hud, get_child_count() - 1)

func on_request_next_scene(next_scene: Scenes.GameScenes) -> void:
	scene_manager.swap_scenes(next_scene, scene_holder, current_scene)

func on_request_quit() -> void:
	get_tree().quit()
