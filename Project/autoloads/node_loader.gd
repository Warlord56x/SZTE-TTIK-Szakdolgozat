extends Node

var scenes_in_progress: Array[Dictionary]


func load_scenes(scene_paths: Array[String]) -> void:
	for scene_path in scene_paths:
		ResourceLoader.load_threaded_request(scene_path)
		scenes_in_progress.append({"scene": scene_path, "progress": []})


func load_scene(scene_path: String) -> void:
	ResourceLoader.load_threaded_request(scene_path)
	scenes_in_progress.append(scene_path)


func _process(_delta: float) -> void:
	for scene in scenes_in_progress:
		ResourceLoader.load_threaded_get_status(scene["scene"], scene["progress"])


func get_all_progress() -> void:
	return
