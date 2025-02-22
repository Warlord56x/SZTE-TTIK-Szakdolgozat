extends State
class_name StateFall

@onready var player: Player = owner as Player


func enter() -> void:
	player.stamina_time.stop()
	player.stamina_time_waiter.stop()
	player.anim_state_m.travel("fall")


func physics_process(delta: float) -> void:

	if player.is_on_floor():
		player.airborne_time = 0.0
	else:
		player.airborne_time += delta

	if player.is_on_floor():
		travel("Default")

	player.velocity.y += player.gravity * delta

	if player.is_on_wall_only() and player.stamina != 0 and player.airborne_time > player.MIN_AIRBORNE_TIME:
		travel("Wall")
	if player.input_direction:
		player.velocity.x = move_toward(player.velocity.x, player.input_direction * player.SPEED, 10)
	player.move_and_slide()


func leave() -> void:
	player.stamina_time.start()
	player.stamina_time_waiter.start()
