extends State
class_name StateEnemyKnockback

@onready var enemy: Enemy = owner as Enemy
@export var gravity: bool = true

var pushback_force: Vector2


func enter() -> void:
	pushback_force = enemy.pushback_force

	var tween := create_tween()
	tween.tween_property(self, "pushback_force", Vector2.ZERO, 0.1)
	tween.finished.connect(back)


func physics_process(delta: float) -> void:
	enemy.velocity += pushback_force
	if gravity:
		enemy.velocity.y += enemy.gravity * delta
	else:
		enemy.velocity.y = move_toward(enemy.velocity.y, 0, 10)
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, 10)
	enemy.move_and_slide()


func leave() -> void:
	print("left the knockback")
