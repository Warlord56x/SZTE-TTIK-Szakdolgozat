extends State
class_name StateEnemyFall

@onready var enemy: Mage = owner as Mage


func enter() -> void:
	enemy.sprite.play("default")


func physics_process(_delta: float) -> void:

	if enemy.is_on_floor():
		if get_parent().previous_state and get_parent().previous_state != self:
			get_parent().back()
		else:
			travel("idle")

	enemy.velocity.y += enemy.gravity * _delta

	if enemy.move_direction:
		enemy.velocity.x = move_toward(enemy.velocity.x, -enemy.move_direction * enemy.movement_speed, 10)
