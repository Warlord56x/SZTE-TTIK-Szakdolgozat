extends State
class_name StateEnemyEscape

@onready var enemy: Enemy = owner as Enemy


func enter():
	print("entered Idle state")


func physics_process(_delta: float) -> void:
	pass


func leave():
	print("left Idle state")
