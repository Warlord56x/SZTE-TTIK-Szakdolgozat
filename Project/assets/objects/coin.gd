extends Area2D
class_name CoinPickup


func save() -> Dictionary:
	return {
		"filename": get_scene_file_path(),
		"parent": get_parent().get_path(),
		"position": SaveManager.vector2_to_array(position)
	}


func _on_player_entered(body : Node2D) -> void:
	if body is Player:
		body.coins += 1
		queue_free()
