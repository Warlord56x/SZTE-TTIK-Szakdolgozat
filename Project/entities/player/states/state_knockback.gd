extends State
class_name StateKnockback


@onready var player: Player = owner as Player

var pushback_force: Vector2


func enter() -> void:
	player.stamina_time.stop()
	player.stamina_time_waiter.stop()
	if player.stamina_wall_drainer.is_stopped():
		player.stamina_wall_drainer.start()

	pushback_force = player.pushback_force

	var tween := create_tween()
	tween.tween_property(self, "pushback_force", Vector2.ZERO, 0.1)
	tween.finished.connect(travel.bind("Fall"))


func physics_process(delta: float) -> void:
	player.velocity += pushback_force
	player.velocity.y += player.gravity * delta
	player.velocity.x = move_toward(player.velocity.x, 0, 10)

	player.move_and_slide()


func leave() -> void:
	player.stamina_time.start()
	player.stamina_time_waiter.start()
	player.stamina_wall_drainer.stop()
