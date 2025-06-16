extends Menu
class_name LoadMenu

@onready var save_list: SaveSlotList = $MarginContainer/VBoxContainer/SaveList
@onready var load_button: Button = %LoadButton
@onready var delete_button: Button = %DeleteButton
@onready var del_conf_dialog: ConfirmationDialog = $DeleteConfirmationDialog

var _slot: SaveSlot = null


func _on_load_button_pressed() -> void:
	if not save_list.slot:
		return
	NodeLoader.done.connect(load_done)
	GameEnv.fade_in("Loading...")
	GameEnv.load_icon(true)
	await GameEnv.fade_step_in
	NodeLoader.load_scene(NodeLoader.GAME_SCENE)


func _on_delete_button_pressed() -> void:
	del_conf_dialog.dialog_text = "Are you sure you want to delete the save slot named: " + _slot.name
	del_conf_dialog.popup_centered()


func load_done(status: ResourceLoader.ThreadLoadStatus) -> void:
	if status == ResourceLoader.THREAD_LOAD_FAILED:
		printerr("Scene loading has been failed")
		return
	var scene: PackedScene = ResourceLoader.load_threaded_get(NodeLoader.GAME_SCENE)
	if scene.resource_path == NodeLoader.GAME_SCENE:
		SaveManager.change_to_loaded_game(scene, save_list.slot)
		GameEnv.fade_out("Loading...")
		GameEnv.load_icon(false)


func _on_save_list_slot_changed(slot: SaveSlot) -> void:
	var is_slot := slot == null
	load_button.disabled = is_slot or slot.all_corrupt
	delete_button.disabled = is_slot
	_slot = slot


func _on_delete_confirmation_dialog_confirmed() -> void:
	_slot.delete()
	save_list.update_list()
