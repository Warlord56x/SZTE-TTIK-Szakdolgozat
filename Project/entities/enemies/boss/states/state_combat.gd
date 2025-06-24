extends State
class_name StateBossCombat

@onready var boss: Boss = owner as Boss
@onready var boss_animation = boss.sprite as AnimatedSprite2D
@onready var bossWeapon := boss.boss_weapon
@onready var move_timer := Timer.new()


func _ready() -> void:
	move_timer.wait_time = 2.0
	move_timer.timeout.connect(random_move)
	add_child(move_timer)


func enter() -> void:
	move_timer.start()
	boss_animation.play("attack")


func physics_process(_delta: float) -> void:
	if abs(boss.velocity.length()) > 0.001:
		if (boss.sprite as AnimatedSprite2D).animation != "attack_move":
			boss_animation.play("attack_move")
	elif boss.is_on_floor():
		if (boss.sprite as AnimatedSprite2D).animation != "attack":
			boss_animation.play("attack")
	boss.move()


func random_move() -> void:
	boss.set_movement_target(boss.random_zone_position())
	if boss.target:
		boss.boss_weapon.attack(boss.target)


func leave() -> void:
	move_timer.stop()
