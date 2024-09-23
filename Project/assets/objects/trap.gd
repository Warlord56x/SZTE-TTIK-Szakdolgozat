extends Area2D

@export var damage : int = 1


func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		$AnimatedSprite2D.frame = 1
		body.hurt(damage)
		body.knock_back(global_position)

		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.frame = 0
