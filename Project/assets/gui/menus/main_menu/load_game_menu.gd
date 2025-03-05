extends Menu


@onready var save_list: SaveSlotList = $MarginContainer/VBoxContainer/SaveList


func _on_load_button_pressed() -> void:
	if not save_list.slot:
		return
	NodeLoader.done.connect(load_done)
	GameEnv.fade_in("Loading...")
	GameEnv.load_icon(true)
	await GameEnv.fade_step_in
	NodeLoader.load_scene("res://game.tscn")


func load_done(scene: PackedScene, status: ResourceLoader.ThreadLoadStatus) -> void:
	if scene == null and status == ResourceLoader.THREAD_LOAD_FAILED:
		printerr("Scene loading has been failed")
		return
	if scene.resource_path == NodeLoader.GAME_SCENE:
		SaveManager.change_to_loaded_game(scene, save_list.slot)
	GameEnv.fade_out("Loading...")
	GameEnv.load_icon(false)
