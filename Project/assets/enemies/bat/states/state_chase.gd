extends State
class_name StateEnemyBatChase

@onready var enemy: Bat = owner as Bat

@onready var chase_timer: Timer = $"../../ChaseTimer"


func _ready() -> void:
	chase_timer.connect("timeout", chase_finished)


func enter() -> void:
	if chase_timer.is_inside_tree():
		chase_timer.start()


func chase_finished() -> void:
	enemy.target = null
	enemy.set_movement_target(enemy.initial_pos)
	travel("idle")


func physics_process(_delta: float) -> void:
	print(chase_timer.time_left)
	enemy.set_movement_target(enemy.target.global_position)
	enemy.move()


func leave() -> void:
	chase_timer.stop()
