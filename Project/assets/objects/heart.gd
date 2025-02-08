extends Area2D


func _on_body_entered(body : Node2D) -> void:
	if body is Player and body.health != body.stats.max_health:
		body.health += 4
		queue_free()
