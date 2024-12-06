extends Resource
class_name Recipe


@export var name: String
@export var icon: Texture2D

@export var required_items: Array[Item]
@export var result_item: Array[Item]


func craft(inventory: Inventory) -> bool:
	var items = inventory.get_items()
	for req in required_items:
		if req not in items:
			return false
	for req in required_items:
		inventory.remove_item(req)
	for res in result_item:
		return inventory.add_item(res)
	return false
