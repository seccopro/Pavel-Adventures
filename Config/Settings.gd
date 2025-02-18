class_name Settings
extends Node

const SETTINGS_PATH: String = "res://Config/settings.cfg"

var settings_file: ConfigFile = ConfigFile.new()
var settings: Dictionary = {
	"audio": {
		"volume": 10
	},
	"controls": {
		"left": [KEY_A, JOY_AXIS_LEFT_X],
		"jump": [KEY_SPACE, JOY_BUTTON_A]
	}
}

func _ready() -> void:
	load_settings()
	save_settings_to_file()

func load_settings() -> void:
	var err = settings_file.load(SETTINGS_PATH)
	if err != OK:
		print("Failed loading settings, error [%s]" % err)
		save_settings_to_file()
		return
	
	const controls_section: String = "controls"
	InputMap.get_actions()
	
	const audio_section: String = "audio"
	for key in settings_file.get_section_keys(audio_section):
		settings[audio_section][key] = settings_file.get_value(audio_section, key)

func save_settings_to_file() -> void:
	for section in settings.keys():
		for key in settings[section]:
			settings_file.set_value(section, key, settings[section][key])
	
	var err = settings_file.save(SETTINGS_PATH)
	if err != OK:
		print("Failed saving settings, error [%s]" % err)
