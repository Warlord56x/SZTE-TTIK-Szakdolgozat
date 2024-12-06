extends Area2D
class_name CoinPickup


func save() -> Dictionary:
	return {
		"filename": get_scene_file_path(),
		"parent": get_parent().get_path(),
		"position": position
	}


func _on_player_entered(body : Node2D) -> void:
	if body is Player:
		body.inventory.add_item(ItemLoader.COIN)
		queue_free()
