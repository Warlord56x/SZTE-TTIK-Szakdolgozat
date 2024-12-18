extends State
class_name StateEnemyCombat

const PROJECTILE := preload("res://assets/player/projectile.tscn")

@onready var enemy: Mage = owner as Mage
@onready var projectile_timer: Timer = $"../../AttackTimer"

var target: Player = null
var attack_flag: bool = false

#TODO: Check why the attack triggers multiple times


func _ready() -> void:
	projectile_timer.connect("timeout", _on_p_timer_timeout)


func attack() -> void:
	attack_flag = true
	enemy.sprite.play("cast")
	await enemy.sprite.animation_finished

	# Have to make sure we awaited the right animation.
	# If the enemy is interrupted AKA changes animations,
	# the finished signal won't fire because it was not finished
	if enemy.sprite.animation != "cast":
		return
	var projectile = PROJECTILE.instantiate()
	projectile.direction = enemy.global_position.direction_to(target.global_position)
	projectile.p_rotation = enemy.global_position.angle_to_point(target.global_position)
	projectile.global_position = enemy.global_position
	projectile.type = 1
	projectile.parent_ref = enemy
	enemy.add_child(projectile)
	enemy.sprite.play("default")
	attack_flag = false


func enter() -> void:
	target = enemy.target
	if projectile_timer.is_stopped():
		projectile_timer.start()
	if projectile_timer.paused:
		projectile_timer.paused = false
	enemy.sprite.play("default")
	enemy.set_movement_target(enemy.global_position)


func physics_process(_delta: float) -> void:
	enemy.move()
	enemy.move_direction = sign(target.global_position.x - enemy.global_position.x)

	if not enemy.is_on_floor():
		travel("fall")


func leave() -> void:
	# Need to avoid stopping the timer,
	# otherwise the attacks can be interrupted indefinitely
	projectile_timer.paused = true
	if enemy.sprite.animation == "cast" and enemy.sprite.is_playing():
		await enemy.sprite.animation_finished


func _on_p_timer_timeout() -> void:
	projectile_timer.wait_time = randf_range(1.0, 1.6)
	attack()
