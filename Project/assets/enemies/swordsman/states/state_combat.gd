extends State
class_name StateEnemySwmanCombat


const PROJECTILE := preload("res://assets/player/projectile.tscn")

@onready var enemy: Swordsman = owner as Swordsman
@onready var attack_timer: Timer = $"../../AttackTimer"

var target: Player = null
var attacking: bool = false


func attack() -> void:
	attacking = true
	# Simply make the tween on the node so that it'll be bound to it,
	# getting freed when the node stops existing
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(enemy.weapon, "position", Vector2(enemy.move_direction * 8, 0), 0.3)
	$"../../SwordSwing".play()
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


func physics_process(_delta: float) -> void:
	if not attacking:
		enemy.sprite.play("move")
		enemy.set_movement_target(enemy.target.global_position)
	enemy.move()
	enemy.move_direction = sign(target.global_position.x - enemy.global_position.x)

	if not enemy.is_on_floor():
		travel("fall")

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
		if body.hurt(1, enemy):
			enemy.sword_hit.play()
		body.knock_back(enemy.global_position, 0.8)
