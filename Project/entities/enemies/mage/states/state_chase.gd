extends State
class_name StateEnemyChase

@onready var enemy: Mage = owner as Mage

@onready var chase_timer: Timer = enemy.chase_timer

func _ready() -> void:
	chase_timer.connect("timeout", chase_finished)


func enter() -> void:
	if chase_timer.is_inside_tree():
		chase_timer.start()
	enemy.sprite.play("move")


func chase_finished() -> void:
	enemy.target = null
	enemy.set_movement_target(enemy.initial_pos)
	travel("idle")


func physics_process(_delta: float) -> void:
	if not enemy.target:
		chase_timer.stop()
		travel("idle")
		return
	if enemy.target and enemy.possible_target:
		travel("combat")
		return
	enemy.set_movement_target(enemy.target.global_position)
	enemy.move()
	if not enemy.is_on_floor():
		travel("fall")


func leave() -> void:
	chase_timer.stop()
