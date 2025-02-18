class_name MainScreen
extends Node2D

@onready var btn_level01: Button = %Level01
@onready var btn_level02: Button = %Level02
@onready var btn_settings: Button = %Settings
@onready var btn_quit: Button = %Quit

func _ready() -> void:
	btn_level01.pressed.connect(on_btn_level01_pressed)
	btn_level02.pressed.connect(on_btn_level02_pressed)
	btn_settings.pressed.connect(on_btn_settings_pressed)
	btn_quit.pressed.connect(on_btn_quit_pressed)
	
	btn_level01.grab_focus()

func on_btn_level01_pressed() -> void:
	SignalBus.request_next_scene.emit(Scenes.GameScenes.StartArea)

func on_btn_level02_pressed() -> void:
	SignalBus.request_next_scene.emit(Scenes.GameScenes.StartArea)

func on_btn_settings_pressed() -> void:
	# TODO(primoz): switch to settings scene
	pass

func on_btn_quit_pressed() -> void:
	SignalBus.request_quit.emit()
