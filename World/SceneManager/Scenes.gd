extends Node

enum GameScenes {
	Invalid,
	GameManager,
	MainScene,
	LoadingScreen,
	StartArea
}

enum GameSceneTransition {
	Invalid,
	NoTransition,
	FadeFromBlack,
	FadeFromWhite,
	FadeToBlack,
	FadeToWhite,
}

class Scene:
	var _path: String
	var _animation: GameSceneTransition
	
	func _init(path: String, animation: GameSceneTransition) -> void:
		_path = path
		_animation = animation

const GAME_MANAGER: String = "res://World/GameManager/GameManager.tscn"
const MAIN_SCENE: String = "res://World/Menu/MainScene.tscn"
const LOADING_SCREEN: String = "res://World/Menu/LoadingScreen.tscn"
const START_AREA: String = "res://World/Levels/StartArea.tscn"

@onready var _scenes: Dictionary = {
		GameScenes.GameManager: Scene.new(GAME_MANAGER, GameSceneTransition.NoTransition),
		GameScenes.MainScene: Scene.new(MAIN_SCENE, GameSceneTransition.FadeToBlack),
		GameScenes.LoadingScreen: Scene.new(LOADING_SCREEN, GameSceneTransition.FadeToBlack),
		GameScenes.StartArea: Scene.new(START_AREA, GameSceneTransition.FadeToBlack),
	}

func get_scene_path(sceneType: GameScenes) -> String:
	var scene: Scene = _scenes.get(sceneType)
	assert(scene != null)
	
	return scene._path

func get_scene_animation(sceneType: GameScenes) -> GameSceneTransition:
	var scene: Scene = _scenes.get(sceneType)
	assert(scene != null)
	
	return scene._animation
