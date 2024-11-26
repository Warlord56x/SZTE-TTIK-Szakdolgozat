extends Control

const GAME_SCENE := "res://game.tscn"

@onready var continue_button: Button = %ContinueButton
@onready var settings_menu: SettingsGameMenu = %Settings
@onready var new_game_menu: Menu = %NewGameMenu
@onready var load_game_menu: Menu = %LoadGameMenu


func _ready() -> void:
	continue_button.disabled = SaveManager.save_slots.is_empty()


func _on_continue_button_pressed() -> void:
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


func _on_new_game_pressed() -> void:
	new_game_menu.switch()


func _on_settings_button_pressed() -> void:
	settings_menu.switch()


func _on_load_game_pressed() -> void:
	load_game_menu.switch()


func _on_exit_pressed() -> void:
	get_tree().quit()
