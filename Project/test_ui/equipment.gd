extends GridContainer


func _can_drop_data(_at_position : Vector2, data : Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("type")

