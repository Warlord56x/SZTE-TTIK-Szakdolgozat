extends State
class_name StateBossIdle


@onready var boss: Boss = owner as Boss


func enter() -> void:
	(boss.sprite as AnimatedSprite2D).play("default")
	boss.target = null
