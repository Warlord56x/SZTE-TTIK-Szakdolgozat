extends State
class_name StateBossIdle


@onready var boss: Boss = owner as Boss
@onready var boss_animation: AnimatedSprite2D = boss.sprite

func enter() -> void:
	if boss.is_on_floor():
		boss_animation.play("default")
	else:
		boss_animation.play("move")

	boss.target = null
	boss.set_movement_target(boss.boss_zone.global_position)


func physics_process(_delta: float) -> void:
	if not boss.is_on_floor() or abs(boss.velocity.length()) > 0.001:
		if boss_animation.animation != "move":
			boss_animation.play("move")
	boss.move()
