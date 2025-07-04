extends State
class_name StateDeath

@onready var player: Player = owner as Player


func enter() -> void:
	GameEnv.input_process = false
	if player.has_node("Hurtbox"):
		player.get_node("Hurtbox").set_deferred("monitoring", false)
	player.anim_tree["parameters/speed/scale"] = 1
	player.anim_state_m.travel("death")
	await player.anim_tree.animation_finished
	GameEnv.fade_in_out(0.3, "You Died")
	await GameEnv.fade_step_wait
	player.drop()

	var camps = get_tree().get_nodes_in_group("Camp").filter(func(c: Camp): return c.camp_name == player.camp)
	if not camps.is_empty() and camps[0]:
		player.global_position = camps[0].global_position
	elif player.checkpoint:
		player.global_position = player.checkpoint.global_position
	else:
		player.global_position = player.DEFAULT_SPAWN_POINT

	GameEnv.respawn_enemies()
	travel("default")


func physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta


func leave() -> void:
	if player.has_node("Hurtbox"):
		player.get_node("Hurtbox").set_deferred("monitoring", true)
	player.recover()
	GameEnv.input_process = true

	player.velocity = Vector2.ZERO
	player.pushback_force = Vector2.ZERO
