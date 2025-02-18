class_name SceneManager
extends Node

signal loading_started(loading_screen: LoadingScreen)
signal loading_completed(loaded_scene: Node)
signal scene_added(loaded_scene: Node, loading_screen: LoadingScreen)

var _loading_screen: LoadingScreen
var _content_path: String
var _load_progress_timer: Timer
var _load_scene_into: Node
var _scene_to_unload: Node
var _loading_in_progress: bool = false

const _loading_screen_scene: PackedScene = preload(Scenes.LOADING_SCREEN)

func _ready() -> void:
	pass

func swap_scenes(scene_to_load: Scenes.GameScenes, load_into: Node, scene_to_unload: Node = null, transition: Scenes.GameSceneTransition = Scenes.GameSceneTransition.Invalid) -> void:
	if _loading_in_progress:
		push_warning("SceneManager is already loading something")
		return
	
	_loading_in_progress = true
	
	_load_scene_into = load_into
	_scene_to_unload = scene_to_unload
	
	if transition == Scenes.GameSceneTransition.Invalid:
		transition = Scenes.get_scene_animation(scene_to_load)
	
	add_loading_screen(transition)
	load_content(Scenes.get_scene_path(scene_to_load))

func add_loading_screen(transition: Scenes.GameSceneTransition):
	_loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	_load_scene_into.add_child(_loading_screen)
	
	_loading_screen.start_transition(transition)
	
	loading_started.emit(_loading_screen)
	await _loading_screen.transition_in_completed

func load_content(path: String) -> void:
	_content_path = path
	var loader = ResourceLoader.load_threaded_request(_content_path)
	if not ResourceLoader.exists(_content_path) or loader == null:
		content_invalid(_content_path)
		return
	
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(monitor_load_status)
	
	_load_scene_into.add_child(_load_progress_timer)
	_load_progress_timer.start()

func monitor_load_status() -> void:
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			content_invalid(_content_path)
			_load_progress_timer.stop()
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if _loading_screen != null:
				_loading_screen.update_bar(load_progress[0] * 100)
		ResourceLoader.THREAD_LOAD_FAILED:
			content_failed_to_load(_content_path)
			_load_progress_timer.stop()
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			content_finished_loading(ResourceLoader.load_threaded_get(_content_path).instantiate() as Node)

func content_failed_to_load(path: String) -> void:
	printerr("error: Failed to load resource: '%s'" % [path])

func content_invalid(path: String) -> void:
	printerr("error: Cannot load resource: '%s'" % [path])

func content_finished_loading(incoming_scene: Node) -> void:
	if _scene_to_unload != null:	
		if _scene_to_unload.has_method("get_data") and incoming_scene.has_method("receive_data"):
			incoming_scene.receive_data(_scene_to_unload.get_data())
	
	_load_scene_into.add_child(incoming_scene)
	scene_added.emit(incoming_scene, _loading_screen)
	
	if _scene_to_unload != null:
		if _scene_to_unload != _load_scene_into:
			_scene_to_unload.queue_free()
	
	if incoming_scene.has_method("init_scene"): 
		incoming_scene.init_scene()

	if _loading_screen != null:
		_loading_screen.finish_transition()
		await _loading_screen.anim_player.animation_finished

	if incoming_scene.has_method("start_scene"): 
		incoming_scene.start_scene()
	
	_loading_in_progress = false
	loading_completed.emit(incoming_scene)
