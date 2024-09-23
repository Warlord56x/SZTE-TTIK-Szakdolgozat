extends Area2D


func _on_player_entered(body : Node2D) -> void:
	if body is Player:
		body.coins += 1
		queue_free()
