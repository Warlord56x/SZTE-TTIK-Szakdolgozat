extends State
class_name StateEnemyBatIdle

@onready var enemy: Bat = owner as Bat


func enter():
	enemy.target = null


func physics_process(_delta: float) -> void:
	enemy.move()
