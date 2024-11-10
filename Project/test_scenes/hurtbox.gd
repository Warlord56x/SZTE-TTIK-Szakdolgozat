extends Area2D
class_name HurtBox

@export var parent_ref: Node2D = owner


func _ready() -> void:
	area_entered.connect(hurtbox_entered)


func hurtbox_entered(hitbox) -> void:
	if not hitbox:
		return

	if parent_ref.has_method("hurt"):
		parent_ref.hurt(hitbox.damage)
