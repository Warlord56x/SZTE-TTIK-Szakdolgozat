class_name Inventory
extends Resource


@export var _items: Array[Item] = []

signal items_changed


func add_item(item: Item) -> bool:
	if _items.has(item):
		if item.stack_size != item.stack:
			item.stack += 1
		else:
			return false
	else:
		_items.append(item)
	items_changed.emit()
	return true


func remove_item(item: Item) -> void:
	if _items.has(item):
		item.stack -= 1
	else:
		_items.erase(item)
	items_changed.emit()


func get_item(index: int) -> Item:
	return _items[index]


func get_items() -> Array[Item]:
	return _items
