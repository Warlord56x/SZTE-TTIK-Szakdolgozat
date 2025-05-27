extends Resource
class_name Recipe


@export var name: String
@export var icon: Texture2D

@export var required_items: Array[Ingredient]
@export var result_item: Array[Ingredient]

enum CraftErrors {
	EXCEEDS_STACK_SIZE,
	MISSING_ITEMS,
	OK,
}


func craft(inventory: Inventory) -> CraftErrors:
	for res in result_item:
		var has_item := inventory.find_item(res.item)
		if has_item != -1:
			var item = inventory.get_item(has_item)
			if item.stack_size == 0:
				return CraftErrors.EXCEEDS_STACK_SIZE
			if item.stack + res.amount > item.stack_size:
				return CraftErrors.EXCEEDS_STACK_SIZE
	
	for req in required_items:
		var has_item = inventory.find_item(req.item)
		if has_item != -1:
			var item = inventory.get_item(has_item)
			if item.stack < req.amount:
				return CraftErrors.MISSING_ITEMS
			continue
		return CraftErrors.MISSING_ITEMS

	for req: Ingredient in required_items:
		for item in req.amount:
			inventory.remove_item(req.item)
	for res: Ingredient in result_item:
		for item in res.amount:
			inventory.add_item(res.item)
	return CraftErrors.OK


func _to_string() -> String:
	return "Recipe: " + name
