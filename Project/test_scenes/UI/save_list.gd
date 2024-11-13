extends ScrollContainer


const ELEMENT := preload("res://test_scenes/UI/save_element.tscn")


func _init() -> void:
	follow_focus = true
	scroll_vertical_custom_step = 61


func _ready() -> void:
	init_list()


func init_list() -> void:
	if not SaveManager.current_slot:
		return

	var save_slot := SaveManager.current_slot
	var group := ButtonGroup.new()
	var box := get_child(0)

	for s: Save in save_slot.saves:
		var element := ELEMENT.instantiate()
		element.time = s.get_saved_at()
		element.screen_shot = s.screen_shot
		element.button_group = group
		element.test = s.name
		box.add_child(element)
