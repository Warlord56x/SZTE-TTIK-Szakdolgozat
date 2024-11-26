extends Menu
class_name NewGameMenu

const GAME_SCENE := "res://game.tscn"

@onready var error: Label = $MarginContainer/VBoxContainer/Error

var new_slot_name := ""


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_slot_name = new_text.to_lower()


func _on_line_edit_text_changed(new_text: String) -> void:
	new_slot_name = new_text.to_lower()
	error.visible = false
	if SaveManager.slot_exists(new_slot_name):
		error.visible = true


func _on_create_play_pressed() -> void:
	if SaveManager.slot_exists(new_slot_name):
		error.visible = true
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
		SaveManager.change_to_new_game(scene, new_slot_name)
	GameEnv.fade_out("Loading...")
	GameEnv.load_icon(false)
