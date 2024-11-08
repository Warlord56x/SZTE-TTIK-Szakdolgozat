extends Node


@onready var window: Window = get_window()


var settings := GameSettings.new()

#var settings := {
		#"fullscreen" : Window.MODE_WINDOWED,
		#"vsync" : DisplayServer.VSYNC_DISABLED,
		#"master_volume" : 50
	#}

var master_bus := "Master"
var master_audio_bus := AudioServer.get_bus_index(master_bus)


func _ready() -> void:
	load_settings()
	settings.to_dict()


func load_settings() -> void:
	var file = FileAccess.open("user://settings.json", FileAccess.READ)

	if not file:
		FileAccess.get_open_error()
		file = FileAccess.open("user://settings.json", FileAccess.WRITE)
		#file.store_string(JSON.stringify(settings))
		return

	var _settings: Dictionary = JSON.parse_string(file.get_as_text())

	#settings.fullscreen = _settings.fullscreen
	#settings.vsync = _settings.vsync
	#settings.master_volume = _settings.master_volume

	#update_settings(_settings)


func update_settings(_settings: GameSettings = settings) -> void:
	window.set_mode(_settings.fullscreen)
	DisplayServer.window_set_vsync_mode(_settings.vsync)
	AudioServer.set_bus_volume_db(master_audio_bus, linear_to_db(_settings.master_volume))
