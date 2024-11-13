extends Control

const GAME_SCENE := "res://game.tscn"

@onready var progress_bar: ProgressBar = %ProgressBar

var progress: Array = []
var scene: PackedScene


func _on_new_game_pressed() -> void:
	ResourceLoader.load_threaded_request(GAME_SCENE, "PackedScene")


func _process(_delta: float) -> void:
	var status := ResourceLoader.load_threaded_get_status(GAME_SCENE, progress)

	progress_bar.value = progress[0] * 100
	if status == ResourceLoader.THREAD_LOAD_LOADED and not scene:
		scene = ResourceLoader.load_threaded_get(GAME_SCENE)
		GameEnv.fade_in_out(0.3)
		await GameEnv.fade_step2
		GameEnv.input_process = true
		get_tree().change_scene_to_packed(scene)
	if scene:
		progress_bar.value = 100
