extends Control

const GAME_SCENE := "res://game.tscn"

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var continue_button: Button = %ContinueButton
@onready var settings_menu: SettingsGameMenu = %Settings
@onready var new_game_menu: Menu = %NewGameMenu

var progress: Array = []
var scene: PackedScene

signal done


func _ready() -> void:
	continue_button.disabled = SaveManager.save_slots.is_empty()


func _process(_delta: float) -> void:
	var status := ResourceLoader.load_threaded_get_status(GAME_SCENE, progress)

	progress_bar.value = progress[0] * 100
	if status == ResourceLoader.THREAD_LOAD_LOADED and not scene:
		scene = ResourceLoader.load_threaded_get(GAME_SCENE)
		done.emit()
		GameEnv.input_process = true
	if scene:
		progress_bar.value = 100


func _on_continue_button_pressed() -> void:
	ResourceLoader.load_threaded_request(GAME_SCENE, "PackedScene")
	await done
	SaveManager.change_to_loaded_game(scene)
	print("Continue...")


func _on_new_game_pressed() -> void:
	ResourceLoader.load_threaded_request(GAME_SCENE, "PackedScene")
	await done
	SaveManager.change_to_new_game(scene)
	print("new game...")


func _on_settings_button_pressed() -> void:
	settings_menu.switch()


func _on_load_game_pressed() -> void:
	new_game_menu.switch()
