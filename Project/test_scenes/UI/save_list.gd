extends ScrollContainer


const ELEMENT := preload("res://test_scenes/UI/save_element.tscn")
@export var slot: int = 0


func _init() -> void:
	follow_focus = true
	scroll_vertical_custom_step = 61


func _ready() -> void:
	var save_slot := SaveManager.save_slots[slot]
	var group := ButtonGroup.new()
	var box := get_child(0)

	for s: Save in save_slot.saves:
		var element := ELEMENT.instantiate()
		element.time = s.get_saved_at()
		element.screen_shot = s.screen_shot
		element.button_group = group
		box.add_child(element)
