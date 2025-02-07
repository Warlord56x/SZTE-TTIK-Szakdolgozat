extends Menu
class_name MainGameMenu

@onready var settings: SettingsMenu = $"../Settings"
@onready var status_menu: StatusMenu = $"../StatusMenu"

@onready var menus: Array[Menu] = [self, settings]
@onready var menus_reversed: Array[Menu] = [settings, self]


var main_open: bool = false:
	set = set_main


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		main_open = !main_open


func set_main(_open: bool) -> void:
	GameEnv.set_blur(_open, 0.7)
	GameEnv.input_process = !_open

	if _open:
		open()
	else:
		for menu: Menu in menus_reversed:
			if menu.visible:
				menu.close()
	main_open = _open


#region Main events
func _on_continue_pressed() -> void:
	main_open = false


func _on_settings_pressed() -> void:
	settings.switch()


func _on_back_pressed() -> void:
	SaveManager.save_game()
	GameEnv.fade_in_out(0.3)
	await GameEnv.fade_step_wait
	GameEnv.set_blur(false)
	get_tree().change_scene_to_packed(GameEnv.MAIN_MENU)


func _on_exit_pressed() -> void:
	SaveManager.save_game()
	get_tree().quit()


func _on_status_pressed() -> void:
	status_menu.switch()
#endregion
