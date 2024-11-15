extends Menu
class_name SettingsGameMenu

@onready var master_volume_slider: VolumeSlider = %MasterVolumeSlider
@onready var fullscreen_check: CheckButton = %FullscreenCheck
@onready var vsync_check: CheckButton = %VsyncCheck


func ready() -> void:
	master_volume_slider.value = Settings.settings.master_volume * 100
	fullscreen_check.button_pressed = Settings.settings.fullscreen
	vsync_check.button_pressed = Settings.settings.vsync


#region Settings events
func _on_master_volume_slider_volume_changed(value: float) -> void:
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
