extends Menu
class_name NewGameMenu

const GAME_SCENE := "res://game.tscn"

@onready var error: Label = $MarginContainer/VBoxContainer/Error
@onready var line_edit: LineEdit = %LineEdit

var new_slot_name := ""

var validator := RegEx.new()


func _ready() -> void:
	super._ready()
	validator.compile("^(?![-_])[a-zA-Z0-9_-]{1,50}(?<![-_])$")


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_slot_name = new_text.to_lower()


func _on_line_edit_text_changed(new_text: String) -> void:
	new_slot_name = new_text.to_lower()
	var validate := is_save_name_valid(new_slot_name)

	error.visible = false
	if not validate.is_empty():
		error.visible = true
		error.text = validate


func is_save_name_valid(slot_name: String) -> String:
	var result := validator.search(slot_name)

	if slot_name.is_empty():
		return "Slot name can't be empty"
	if SaveManager.slot_exists(slot_name):
		return "Slot already exists"
	if slot_name.length() < 3:
		return "Slot name must contain at least 3 characters"
	if result == null or result.get_string() != slot_name:
		return "Slot name can only contain '-_', but can't start with them."
	return ""


func _on_create_play_pressed() -> void:
	if error.visible:
		return
	NodeLoader.done.connect(load_done)
	GameEnv.fade_in("Loading...")
	GameEnv.load_icon(true)
	await GameEnv.fade_step_in
	NodeLoader.load_scene(GAME_SCENE)


func load_done(scene_str: String, status: ResourceLoader.ThreadLoadStatus) -> void:
	var scene = ResourceLoader.load_threaded_get(scene_str)
	if scene == null and status == ResourceLoader.THREAD_LOAD_FAILED:
		printerr("Scene loading has failed")
		return
	
	if scene.resource_path == GAME_SCENE:
		SaveManager.change_to_new_game(scene, new_slot_name)
	GameEnv.fade_out("Loading...")
	GameEnv.load_icon(false)
