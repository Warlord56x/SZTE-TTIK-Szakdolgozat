extends Area2D


func _on_body_entered(body : Node2D):
	if body is CharacterBody2D:
		if body.has_method("hurt"):
			body.hurt(body.health)
