extends State
class_name StateBossChase


@onready var boss: Boss = owner as Boss
@onready var chase_timer: Timer = $"../../ChaseTimer"


func _ready() -> void:
	chase_timer.connect("timeout", chase_finished)


func enter() -> void:
	(boss.sprite as AnimatedSprite2D).play("move")
	if chase_timer.is_inside_tree():
		chase_timer.start()


func chase_finished() -> void:
	boss.target = null
	boss.set_movement_target(boss.initial_pos)
	travel("idle")


func physics_process(_delta: float) -> void:
	if not boss.target:
		chase_timer.stop()
		return
	boss.set_movement_target(boss.target.global_position)
	boss.move()


func leave() -> void:
	chase_timer.stop()
