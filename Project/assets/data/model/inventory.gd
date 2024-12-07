class_name Inventory


var _items: Array[Item] = []

signal items_changed(item: Item)


func _init() -> void:
	_items.resize(8)


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
		if item is WeaponItem or item is ConsumableItem:
			_items.insert(0, _item)
		else:
			_items.append(_item)
	items_changed.emit(_item)
	return true


func set_items(array: Array[Item]) -> void:
	_items = array


func remove_item(item: Item) -> void:
	var it := find_item(item)
	var _item = get_item(it)

	if _item:
		if _item.stack_size > 0:
			get_item(it).stack -= 1
		else:
			_items.remove_at(it)
	items_changed.emit(_item)


func fill_action_slots(array: Array[Item]) -> void:
	for item in array:
		_items.erase(item)
	array.append_array(_items)
	_items.clear()
	_items = array
	items_changed.emit(null)


func find_item(item: Item) -> int:
	if not item:
		return -1
	for it: int in len(_items):
		if not _items[it]:
			continue
		if _items[it].name == item.name:
			return it
	return -1


func get_item(index: int) -> Item:
	if index >= _items.size() or index < 0:
		return null
	return _items[index]


func get_items() -> Array[Item]:
	return _items
