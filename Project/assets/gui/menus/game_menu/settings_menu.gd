extends Menu
class_name SettingsMenu

@onready var master_volume_slider: VolumeSlider = %MasterVolumeSlider
@onready var vsync_check: CheckButton = %VsyncCheck
@onready var option_button: OptionButton = %OptionButton


func ready() -> void:
	master_volume_slider.value = Settings.settings.master_volume * 100
	vsync_check.button_pressed = Settings.settings.vsync
	option_button.selected = Settings.settings.fullscreen


#region Settings events
func _on_master_volume_slider_volume_changed(value: float) -> void:
	Settings.settings.master_volume = value


func _on_option_button_item_selected(index: int) -> void:
	Settings.settings.fullscreen = option_button.get_item_id(index) as Window.Mode


func _on_vsync_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Settings.settings.vsync = DisplayServer.VSYNC_ENABLED
	else:
		Settings.settings.vsync = DisplayServer.VSYNC_DISABLED


func _on_apply_pressed() -> void:
	Settings.update_settings()
	Settings.save_settings()
#endregion
