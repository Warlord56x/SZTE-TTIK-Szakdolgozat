class_name Inventory


var _items: Array[Item] = []

signal items_changed(item: Item)


func add_item(item: Item) -> bool:
	var it := find_item(item)
	var _item := get_item(it)

	if _item:
		if _item.stack_size != _item.stack:
			_item.stack += 1
		else:
			return false
	else:
		_item = item
		_items.append(item)
	items_changed.emit(_item)
	return true


func remove_item(item: Item) -> void:
	var it := find_item(item)
	var _item = get_item(it)

	if _item:
		get_item(it).stack -= 1
	items_changed.emit(_item)


func find_item(item: Item) -> int:
	for it: int in range(_items.size()):
		if _items[it].name == item.name:
			return it
	return -1


func get_item(index: int) -> Item:
	if index == -1:
		return null
	return _items[index]


func get_items() -> Array[Item]:
	return _items
