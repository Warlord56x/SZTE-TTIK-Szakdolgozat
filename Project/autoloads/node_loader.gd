extends Node

var scenes_in_progress: Dictionary
var all_progress := 0.0

signal done(scene: PackedScene)


func load_scenes(scene_paths: Array[String]) -> void:
	for scene_path in scene_paths:
		ResourceLoader.load_threaded_request(scene_path, "PackedScene", false, ResourceLoader.CACHE_MODE_IGNORE)
		scenes_in_progress[scene_path] = []
	#print(scenes_in_progress)


func load_scene(scene_path: String) -> void:
	ResourceLoader.load_threaded_request(scene_path)
	scenes_in_progress[scene_path] = []


func _process(_delta: float) -> void:

	for scene in scenes_in_progress:
		#if all_progress / scenes_in_progress.size() == 1.0:
			#print("Should be done")
			#done.emit()
			#all_progress = 0.0
			#scenes_in_progress.clear()
			#break
		var d = ResourceLoader.load_threaded_get_status(scene, scenes_in_progress[scene])
		if d == ResourceLoader.THREAD_LOAD_LOADED:
			done.emit(ResourceLoader.load_threaded_get(scene))
			scenes_in_progress.erase(scene)
			return
		#all_progress += scenes_in_progress[scene][0]
		#prints(all_progress, scenes_in_progress.size())
