extends Menu
class_name NewGameMenu


var new_slot_name := ""


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_slot_name = new_text


func _on_line_edit_text_changed(new_text: String) -> void:
	new_slot_name = new_text


func _on_create_play_pressed() -> void:
	NodeLoader.done.connect(p)
	NodeLoader.load_scenes([
		"res://test_scenes/UI/volume_slider.tscn",
		"res://test_scenes/UI/save_element.tscn",
		"res://test_scenes/UI/game_menu.tscn",
		])


func p(s: PackedScene) -> void:
	prints("NICE:", s)
	get_parent().add_child(s.instantiate())
