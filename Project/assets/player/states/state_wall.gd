extends State
class_name StateWall

@onready var player: Player = owner as Player


func enter() -> void:
	player.anim_state_m.travel("wall_slide")
	player.stamina_time.stop()
	player.stamina_time_waiter.stop()
	if player.stamina_wall_drainer.is_stopped():
		player.stamina_wall_drainer.start()
	player.velocity.y = 0
	player.airborne_time = 0


func physics_process(_delta: float) -> void:

	if player.input_direction:
		player.move_direction.x = sign(player.input_direction)

	if player.stamina == 0:
		travel("Fall")
		return
 
	if not player.is_on_floor():
		player.velocity.y = player.gravity * 0.01

	if !player.is_on_wall_only():
		travel("Fall")
		return

	if player.input_direction:
		player.velocity.x = player.input_direction

	player.dash_count = 0
	if Input.is_action_just_pressed("jump"):
		var wall_normal = player.get_wall_normal()
		var b = player.move_direction.bounce(wall_normal)
		b.x *= player.SPEED
		if wall_normal.x == player.move_direction.x:
			b.x *= -1
		b.y = player.MAX_JUMP_VELOCITY
		player.velocity = b;
		player.move_direction *= -1
		player.input_direction = player.move_direction.x
		player.stamina -= 1
		travel("Fall")

	player.move_and_slide()


func leave() -> void:
	player.stamina_time.start()
	player.stamina_time_waiter.start()
	player.stamina_wall_drainer.stop()
