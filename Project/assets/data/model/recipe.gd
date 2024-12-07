extends Resource
class_name Recipe


@export var name: String
@export var icon: Texture2D

@export var required_items: Array[Item]
@export var result_item: Array[Item]


func craft(inventory: Inventory) -> bool:
	for res in result_item:
		var has_item := inventory.find_item(res)
		if has_item != -1:
			var item = inventory.get_item(has_item)
			if item.stack + 1 > item.stack_size:
				return false
	
	for req in required_items:
		if inventory.find_item(req) == -1:
			return false

	for req in required_items:
		inventory.remove_item(req)
	for res in result_item:
		inventory.add_item(res)
	return true
