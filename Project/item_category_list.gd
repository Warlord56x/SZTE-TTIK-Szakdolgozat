@tool
extends VBoxContainer
class_name ItemCategoryList

@onready var label: Label = $Label
@onready var item_list: ItemList = $ItemList

@export var category: GDScript = null:
	set(c):
		category = c
		update_items()

var inventory: Inventory:
	set(inv):
		inventory = inv
		update_items()

signal item_activated(item: Item, pos: Vector2)


func _ready() -> void:
	update_items()


func update_items() -> void:
	if not inventory or not label or not item_list:
		return
	var category_display_name := category.get_global_name()
	category_display_name = category_display_name.to_snake_case()
	category_display_name = category_display_name.replace("_", " ")

	label.text = category_display_name + "s"
	item_list.clear()
	for item in inventory.get_items():
		if is_instance_of(item, category):
			var display_name := item.name
			if item.stack_size > 0:
				display_name += str(" x",item.stack)
			var idx = item_list.add_item(display_name, item.icon)
			item_list.set_item_metadata(idx, item)
	if item_list.item_count == 0:
		item_list.add_item("No items", null, false)


func _on_item_list_focus_exited() -> void:
	item_list.deselect_all()


func _on_item_list_item_activated(index: int) -> void:
	item_activated.emit(item_list.get_item_metadata(index), position)
