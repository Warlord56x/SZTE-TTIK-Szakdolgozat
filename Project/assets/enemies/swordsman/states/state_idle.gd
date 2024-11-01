extends State
class_name StateEnemySwmanIdle

@onready var enemy: Swordsman = owner as Swordsman


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
