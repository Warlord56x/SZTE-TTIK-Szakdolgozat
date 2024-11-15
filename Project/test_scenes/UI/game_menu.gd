extends Control

@onready var main: Menu = $Margin/MenuContainer/Main
@onready var settings: Menu = $Margin/MenuContainer/Settings
@onready var save_game: Menu = $Margin/MenuContainer/SaveGame
@onready var load_game: Menu = $Margin/MenuContainer/LoadGame

@onready var master_volume_slider: VolumeSlider = %MasterVolumeSlider
@onready var fullscreen_check: CheckButton = %FullscreenCheck
@onready var vsync_check: CheckButton = %VsyncCheck
@onready var menus: Array[Menu] = [main,settings,save_game,load_game]
@onready var menus_reversed: Array[Menu] = [load_game,save_game,settings,main]


var main_open: bool = false:
	set = set_main


func _ready() -> void:
	master_volume_slider.value = Settings.settings.master_volume * 100
	fullscreen_check.button_pressed = Settings.settings.fullscreen
	vsync_check.button_pressed = Settings.settings.vsync

	for menu: Menu in menus:
		menu.scale.x = 0.001
		var menu_effect: EffectLayer = menu.effect
		menu_effect.progress = 1.0
		menu.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		main_open = !main_open


func set_main(_open: bool) -> void:
	GameEnv.set_blur(_open, 0.7)
	GameEnv.input_process = !_open

	if _open:
		main.open()
	else:
		for menu: Menu in menus_reversed:
			if menu.visible:
				menu.close()
	main_open = _open


#region Settings events
func _on_volume_slider_volume_changed(value: float) -> void:
	Settings.settings.master_volume = value


func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.settings.fullscreen = Window.MODE_FULLSCREEN
	else:
		Settings.settings.fullscreen = Window.MODE_WINDOWED


func _on_vsync_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.settings.vsync = DisplayServer.VSYNC_ENABLED
	else:
		Settings.settings.vsync = DisplayServer.VSYNC_DISABLED


func _on_apply_pressed() -> void:
	Settings.update_settings()
	Settings.save_settings()
#endregion
