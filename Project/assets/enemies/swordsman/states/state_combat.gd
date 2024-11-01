extends State
class_name StateEnemySwmanCombat

const PROJECTILE := preload("res://assets/player/projectile.tscn")

@onready var enemy: Swordsman = owner as Swordsman
@onready var attack_timer: Timer = $"../../AttackTimer"

var target: Player = null
var attacking: bool = false

func attack() -> void:
	attacking = true
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(enemy.weapon, "position", Vector2(enemy.move_direction * 8, 0), 0.3)
	tween.play()
	enemy.sprite.play("hit")
	enemy.animation_player.play("hit")

	enemy.weapon.flip_h = enemy.move_direction < 0
	enemy.weapon.position = Vector2(0, -8)

	await enemy.animation_player.animation_finished

	enemy.weapon.position = Vector2(0, -8)
	attacking = false


func enter() -> void:
	target = enemy.target
	attack_timer.start()


func physics_process(delta: float) -> void:
	if not attacking:
		enemy.sprite.play("move")
		enemy.set_movement_target(enemy.target.global_position)
	enemy.move()

	if not enemy.is_on_floor():
		# Want to avoid changing state since that resets the timer
		#travel("fall")
		enemy.velocity.y += enemy.gravity * delta

		if enemy.move_direction:
			enemy.velocity.x = move_toward(enemy.velocity.x, -enemy.move_direction * enemy.movement_speed, 10)
	if enemy.target.global_position.distance_to(enemy.global_position) < 10:
		if not attacking:
			enemy.sprite.play("default")
		if  attack_timer.time_left == 0:
			attack()
			attack_timer.start()


func leave() -> void:
	attack_timer.stop()


func _on_weapon_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body = body as Player
		body.hurt(1, enemy)
		body.knock_back(enemy.global_position, 0.8)
