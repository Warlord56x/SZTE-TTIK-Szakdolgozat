extends ScrollContainer
class_name SaveSlotList

const ELEMENT := preload("res://assets/gui/menus/menu_elements/save_element.tscn")

var slot: SaveSlot


func _init() -> void:
	follow_focus = true
	scroll_vertical_custom_step = 61


func _ready() -> void:
	init_list()


func init_list() -> void:
	var group := ButtonGroup.new()
	var box := get_child(0)

	for s: SaveSlot in SaveManager.save_slots:
		var element := ELEMENT.instantiate()
		element.time = s.get_saved_at()
		element.slot = s
		element.button_group = group
		element.test = s.name
		box.add_child(element)
		element.pressed.connect(item_checked)


func item_checked(item_slot: SaveSlot):
	slot = item_slot
