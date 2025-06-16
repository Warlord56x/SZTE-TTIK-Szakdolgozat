extends ScrollContainer
class_name SaveSlotList

const ELEMENT := preload("res://gui/menus/menu_elements/save_element.tscn")

var slot: SaveSlot
var button_group := ButtonGroup.new()

signal slot_changed(slot: SaveSlot)


func _init() -> void:
	follow_focus = true
	scroll_vertical_custom_step = 61


func _ready() -> void:
	init_list()


func update_list() -> void:
	for ch: SaveElement in get_child(0).get_children():
		if ch.pressed.is_connected(item_checked):
			ch.pressed.disconnect(item_checked)
		ch.queue_free()
	init_list()


func init_list() -> void:
	var box := get_child(0)

	for s: SaveSlot in SaveManager.save_slots:
		var element: SaveElement = ELEMENT.instantiate()
		element.slot = s
		element.button_group = button_group
		box.add_child(element)
		element.pressed.connect(item_checked)


func item_checked(item_slot: SaveSlot):
	slot = item_slot
	slot_changed.emit(slot)
