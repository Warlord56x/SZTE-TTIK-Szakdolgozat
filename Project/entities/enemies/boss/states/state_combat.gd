extends State
class_name StateBossCombat

@onready var boss: Boss = owner as Boss
@onready var bossWeapon := boss.boss_weapon
@onready var move_timer := Timer.new()


func _ready() -> void:
	move_timer.wait_time = 2.0
	move_timer.timeout.connect(random_move)
	add_child(move_timer)


func enter() -> void:
	move_timer.start()


func random_move() -> void:
	boss.set_movement_target(boss.random_zone_position())
	if boss.target:
		boss.boss_weapon.attack(boss.target)


func leave() -> void:
	move_timer.stop()
