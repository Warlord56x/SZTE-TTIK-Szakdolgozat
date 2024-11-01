extends Enemy
class_name Bat


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player:
		target = body
		state_machine.travel("Chase")


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("hurt") and body is Player:
		body = body as Player
		body.hurt(1)
		body.knock_back(global_position, 0.6)
		knock_back(body.global_position, 0.6)
