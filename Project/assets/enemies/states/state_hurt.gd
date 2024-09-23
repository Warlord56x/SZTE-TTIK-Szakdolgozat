extends State
class_name StateEnemyHurt

@onready var enemy: Enemy = owner as Enemy


func enter() -> void:
	print("entered state Hurt")
	enemy.modulate.a = 1.0

	var inv_tween = get_tree().create_tween()
	inv_tween.tween_property(enemy, "modulate:a", 0.2, 0.05)
	inv_tween.play()

	await get_tree().create_timer(0.1).timeout

	travel("Idle")


func physics_process(_delta: float) -> void:
	enemy.velocity = enemy.pushback_force


func leave() -> void:
	print("left state Hurt")
	var inv_tween = get_tree().create_tween()
	inv_tween.tween_property(enemy, "modulate:a", 1.0, 0.05)
	inv_tween.play()
	enemy.modulate.a = 1.0
