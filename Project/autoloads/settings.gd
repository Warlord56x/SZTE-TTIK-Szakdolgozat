extends Node


@onready var window: Window = get_window()

var settings := GameSettings.new()

var master_bus := "Master"
var master_audio_bus := AudioServer.get_bus_index(master_bus)

signal update


func _ready() -> void:
	load_settings()


func validate_settings(save: Dictionary) -> bool:

	for key in save:
		if key not in settings:
			return false

	for key in settings.to_dict():
		if key not in save:
			return false

	return true


func load_settings() -> void:
	var file = FileAccess.open("user://settings.json", FileAccess.READ)

	if not file:
		save_settings()
		return

	var _settings: Dictionary = JSON.parse_string(file.get_as_text())

	for setting in settings.to_dict():
		settings.set(setting, _settings[setting])

	update_settings()


func save_settings() -> void:
	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(settings.to_dict()))


func update_settings() -> void:
	window.set_mode(settings.fullscreen)
	DisplayServer.window_set_vsync_mode(settings.vsync)
	AudioServer.set_bus_volume_db(master_audio_bus, linear_to_db(settings.master_volume))
	update.emit()
