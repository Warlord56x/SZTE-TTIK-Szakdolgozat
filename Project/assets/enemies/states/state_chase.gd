extends State
class_name StateEnemyChase

@onready var enemy: Mage = owner as Mage

@onready var chase_timer: Timer = $"../../ChaseTimer"


func enter() -> void:
	if chase_timer.is_inside_tree():
		chase_timer.start()
	enemy.set_movement_target(enemy.target.global_position)
	enemy.sprite.play("move")


func chase_finished() -> void:
	enemy.target = null
	enemy.set_movement_target(enemy.initial_pos)
	travel("idle")


func physics_process(_delta: float) -> void:
	enemy.move()
	if not enemy.is_on_floor():
		enemy.state_machine.travel("fall")


func leave() -> void:
	chase_timer.stop()
