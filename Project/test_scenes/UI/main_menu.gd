extends Control

const GAME_SCENE := "res://game.tscn"

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var continue_button: Button = $CenterContainer/PanelContainer/VBoxContainer/Continue

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


func _on_continue_pressed() -> void:
	ResourceLoader.load_threaded_request(GAME_SCENE, "PackedScene")
	done.connect(test2)
	print("Continue...")


func _on_new_game_pressed() -> void:
	ResourceLoader.load_threaded_request(GAME_SCENE, "PackedScene")
	done.connect(test1)
	print("new game...")


func test1() -> void:
	GameEnv.fade_in_out(0.3)
	await GameEnv.fade_step2
	SaveManager.new_game("slot0")
	get_tree().change_scene_to_packed(scene)


func test2() -> void:
	SaveManager.change_to_loaded_game(scene, SaveManager.save_slots[0])
