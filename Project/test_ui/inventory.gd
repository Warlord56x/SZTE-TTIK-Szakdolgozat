extends GridContainer

func _can_drop_data(_at_position : Vector2, data : Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("data") and data.has("slot") and data.slot


func _drop_data(_at_position : Vector2, data : Variant) -> void:
	#var item = Item.make_item(data.data)
	#add_child(item)
	pass
