extends Enemy
class_name Mage


func get_damage() -> int:
	return round(damage + stats.intelligence / 3.0)


func physics_process(_delta: float) -> void:

	if velocity:
		if target:
			move_direction = sign(target.global_position.x - global_position.x)
		else:
			move_direction = sign(velocity.x)

	sprite.flip_h = move_direction < 0
