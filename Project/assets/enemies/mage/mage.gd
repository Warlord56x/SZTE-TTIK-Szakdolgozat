extends Enemy
class_name Mage


func physics_process(_delta: float) -> void:

	if velocity:
		if target:
			move_direction = sign(target.global_position.x - global_position.x)
		else:
			move_direction = sign(velocity.x)

	sprite.flip_h = move_direction < 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not invincible:
		body.hurt(1, self)
		body.knock_back(global_position, 0.6)


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player:
		target = body
		if not ai:
			return
		state_machine.travel("combat")


func _on_detect_range_body_exited(body : Node2D) -> void:
	if body is Player:
		target = body
		if not ai:
			return
		state_machine.travel("Chase")
