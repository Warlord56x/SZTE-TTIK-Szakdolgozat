extends Control

const GAME_SCENE := "res://game.tscn"

@onready var continue_button: Button = %ContinueButton
@onready var settings_menu: SettingsMenu = %Settings
@onready var new_game_menu: Menu = %NewGameMenu
@onready var load_game_menu: Menu = %LoadGameMenu

@onready var menu_groups := {
	"settings": [settings_menu],
	"management": [new_game_menu, load_game_menu]
}

var history: Array[Menu] = []


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var last_open: Menu = history.pop_back()
		if last_open:
			last_open.close()


func _ready() -> void:
	continue_button.disabled = SaveManager.save_slots.is_empty()


func _on_continue_button_pressed() -> void:
	if not NodeLoader.done.is_connected(load_done):
		NodeLoader.done.connect(load_done)
	GameEnv.fade_in("Loading...")
	GameEnv.load_icon(true)
	await GameEnv.fade_step_in
	NodeLoader.load_scene(GAME_SCENE)


func load_done(scene: PackedScene, status: ResourceLoader.ThreadLoadStatus) -> void:
	if scene == null and status == ResourceLoader.THREAD_LOAD_FAILED:
		printerr("Scene loading has been failed")
		return
	if scene.resource_path == GAME_SCENE:
		SaveManager.change_to_loaded_game(scene)
	GameEnv.fade_out("Loading...")
	GameEnv.load_icon(false)


func open_menu(menu: Menu) -> void:
	var open_group: String
	for group in menu_groups:
		if menu in menu_groups[group]:
			open_group = group
			break
	
	for group in menu_groups:
		if group != open_group:
			for m: Menu in menu_groups[group]:
				if m == menu_groups[group][-1]:
					await m.close()
				else:
					m.close()
	menu.switch()
	if menu.visible:
		history.append(menu)
	else:
		history.erase(menu)


func _on_new_game_pressed() -> void:
	open_menu(new_game_menu)


func _on_settings_button_pressed() -> void:
	open_menu(settings_menu)


func _on_load_game_pressed() -> void:
	open_menu(load_game_menu)


func _on_exit_pressed() -> void:
	get_tree().quit()
