extends Node

const GAME_SCENE := "res://game.tscn"

var scenes_in_progress: Dictionary
var all_progress := 0.0

signal done(scene: PackedScene, status: ResourceLoader.ThreadLoadStatus)


func load_scenes(scene_paths: Array[String]) -> void:
	for scene_path in scene_paths:
		ResourceLoader.load_threaded_request(scene_path, "PackedScene")
		scenes_in_progress[scene_path] = []


func load_scene(scene_path: String) -> void:
	ResourceLoader.load_threaded_request(scene_path, "PackedScene")
	scenes_in_progress[scene_path] = []


func _process(_delta: float) -> void:
	var marked_done := []

	for scene: String in scenes_in_progress:
		var status = ResourceLoader.load_threaded_get_status(scene, scenes_in_progress[scene])

		if status == ResourceLoader.THREAD_LOAD_LOADED:
			done.emit(ResourceLoader.load_threaded_get(scene), status)
			marked_done.append(scene)
		if status == ResourceLoader.THREAD_LOAD_FAILED:
			done.emit(null, status)
			marked_done.append(scene)
			printerr("The scene has failed to load")

	for scene: String in marked_done:
		scenes_in_progress.erase(scene)
	marked_done.clear()
