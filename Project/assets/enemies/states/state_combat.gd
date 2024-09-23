extends State
class_name StateEnemyCombat

const PROJECTILE := preload("res://assets/player/projectile.tscn")

@onready var enemy: Mage = owner as Mage
@onready var projectile_timer: Timer = $"../../AttackTimer"

var target: Player = null
var attack_flag: bool = false


func attack() -> void:
	enemy.sprite.play("cast")
	await enemy.sprite.animation_finished
	var projectile = PROJECTILE.instantiate()
	projectile.direction = enemy.global_position.direction_to(target.global_position)
	projectile.p_rotation = enemy.global_position.angle_to_point(target.global_position)
	projectile.global_position = enemy.global_position
	projectile.type = 1
	enemy.add_child(projectile)
	projectile.owner = enemy
	enemy.sprite.play("default")


func enter() -> void:
	target = enemy.target
	projectile_timer.start()
	enemy.sprite.play("default")
	enemy.set_movement_target(enemy.global_position)


func physics_process(_delta: float) -> void:
	enemy.move()
	enemy.move_direction = sign(target.global_position.x - enemy.global_position.x)
	if not enemy.is_on_floor():
		enemy.state_machine.travel("fall")


func leave() -> void:
	projectile_timer.stop()


func _on_p_timer_timeout() -> void:
	attack()
