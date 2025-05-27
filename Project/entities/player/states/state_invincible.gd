extends State
class_name StateInvincible

@onready var player: Player = owner as Player

var inv_tween: Tween


func enter() -> void:
	player.modulate.a = 1.0

	inv_tween = get_tree().create_tween()
	inv_tween.tween_property(player, "modulate:a", 0.2, 0.05)

	inv_tween.play()

	await get_tree().create_timer(0.1).timeout

	travel("Fall")


func physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.gravity * delta
	#player.velocity = player.pushback_force
	player.move_and_slide()


func leave() -> void:
	inv_tween.kill()
	inv_tween = get_tree().create_tween()
	inv_tween.tween_property(player, "modulate:a", 1.0, 0.05)
	inv_tween.play()
	player.modulate.a = 1.0
