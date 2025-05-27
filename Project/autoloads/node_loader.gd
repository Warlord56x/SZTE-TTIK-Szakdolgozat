extends Node

const GAME_SCENE := "res://game.tscn"

var scenes_in_progress: Dictionary

signal done(res: String, status: ResourceLoader.ThreadLoadStatus)


func load_scenes(scene_paths: Array[String]) -> void:
	for scene_path in scene_paths:
		ResourceLoader.load_threaded_request(scene_path)
		scenes_in_progress[scene_path] = []


func load_scene(scene_path: String) -> void:
	ResourceLoader.load_threaded_request(scene_path, "PackedScene")
	scenes_in_progress[scene_path] = []


func _process(_delta: float) -> void:

	for scene: String in scenes_in_progress:
		var status = ResourceLoader.load_threaded_get_status(scene, scenes_in_progress[scene])

		if status == ResourceLoader.THREAD_LOAD_LOADED:
			done.emit(scene, status)
			scenes_in_progress.erase(scene)
		if status == ResourceLoader.THREAD_LOAD_FAILED:
			done.emit(null, status)
			printerr("The scene has failed to load")
