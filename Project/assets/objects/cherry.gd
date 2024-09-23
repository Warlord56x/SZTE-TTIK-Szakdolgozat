extends Area2D


func _on_body_entered(body : Node2D) -> void:
	if body is Player and body.mana != body.max_mana:
		body.mana += 4
		queue_free()
