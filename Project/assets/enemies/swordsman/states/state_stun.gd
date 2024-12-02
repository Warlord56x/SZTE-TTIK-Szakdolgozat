extends State
class_name StateEnemySwmanStun

@onready var enemy: Swordsman = owner as Swordsman
@export var duration: float = 1.0


func enter() -> void:
	enemy.sprite.play("default")
	enemy.velocity = Vector2.ZERO
	await get_tree().create_timer(duration).timeout
	back()


func physics_process(_delta: float) -> void:
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, enemy.movement_speed)
