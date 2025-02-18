extends State
class_name StateEnemyKnockBack

@onready var enemy: Enemy = owner as Enemy

var pushback_force: Vector2


func enter() -> void:
	pushback_force = enemy.pushback_force

	var tween := create_tween()
	tween.tween_property(self, "pushback_force", Vector2.ZERO, 0.1)
	tween.finished.connect(back)


func physics_process(delta: float) -> void:
	enemy.velocity += pushback_force
	enemy.velocity.y += enemy.gravity * delta
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, 10)

	enemy.move_and_slide()


func leave() -> void:
	pass
