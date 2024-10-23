extends State
class_name StateDeath

@onready var player: Player = owner as Player
@onready var col_layer: int = player.collision_layer



func enter() -> void:
	player.anim_tree["parameters/speed/scale"] = 1
	player.anim_state_m.travel("death")
	await player.anim_tree.animation_finished
	player.anim_state_m.travel("idle")
	travel("Fall")
	player.collision_layer = 0


func physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta


func leave() -> void:
	player.collision_layer = col_layer
	player.health = player.max_health
	player.stamina = player.max_stamina
	player.mana = player.max_mana
	#player.arrows = player.max_arrows

	player.velocity = Vector2.ZERO
	player.pushback_force = Vector2.ZERO

	if player.checkpoint:
		player.global_position = player.checkpoint.global_position
	else:
		player.global_position = player.DEFAULT_SPAWN_POINT
