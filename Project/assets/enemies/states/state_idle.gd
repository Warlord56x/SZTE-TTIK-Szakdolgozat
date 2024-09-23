extends State
class_name StateEnemyIdle

@onready var enemy: Mage = owner as Mage


func enter():
	enemy.target = null
	enemy.sprite.play("default")


func physics_process(_delta: float) -> void:
	if not enemy.is_on_floor():
		travel("fall")
	enemy.move()
	if enemy.velocity.length() > 0.1:
		enemy.sprite.play("move")
	else:
		enemy.sprite.play("default")
