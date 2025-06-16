extends Node2D
class_name BossWeaponScene

@onready var weapon_animations: AnimatedSprite2D = $WeaponAnimations
@onready var hitbox: Hitbox = $WeaponAnimations/Hitbox

signal attack_finished


func _ready() -> void:
	hitbox.monitorable = false
	visible = false


func attack(target: Player) -> void:
	var attack_direction = -target.move_direction
	var target_x = target.global_position.x - 5 * attack_direction.x
	var target_y = target.global_position.y
	global_position = Vector2(target_x, target_y)
	attack_animation()


func attack_animation() -> void:
	visible = true
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	tween.tween_property(self, "rotation_degrees", 90, 0.1)
	tween.tween_property(self, "rotation_degrees", 0, 0.1)
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	await tween.step_finished
	await tween.step_finished
	hitbox.monitorable = true
	await tween.finished
	attack_finished.emit()
	hitbox.monitorable = false
	visible = false
