extends AnimatedSprite2D
class_name WeaponExperimental


@export var hitbox: bool = false
@export var direction: float = 1
signal hit(body: Node2D)


func _on_weapon_hitbox_body_entered(body: Node2D) -> void:
	hit.emit(body)
