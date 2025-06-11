extends State
class_name StateEnemyBatChase

@onready var enemy: Bat = owner as Bat

@onready var chase_timer: Timer = $"../../ChaseTimer"


func _ready() -> void:
	chase_timer.connect("timeout", chase_finished)


func enter() -> void:
	pass


func chase_finished() -> void:
	enemy.target = null
	enemy.set_movement_target(enemy.initial_pos)
	travel("idle")


func physics_process(_delta: float) -> void:
	if not enemy.target:
		chase_timer.stop()
		return
	enemy.set_movement_target(enemy.target.global_position)
	enemy.move()


func leave() -> void:
	chase_timer.stop()
