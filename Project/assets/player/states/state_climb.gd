extends State
class_name StateClimb

@onready var player: Player = owner as Player


func enter() -> void:
	#player.position.x = player.ladder_pos
	player.velocity = Vector2.ZERO
	player.position.x = player.ladder_pos

	player.on_ladder = true
	player.anim_state_m.travel("climb_idle")
	player.request_interaction_visible(false)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		player.velocity.y = player.MAX_JUMP_VELOCITY
		player.stamina -= 2
		travel("fall")

	if event.is_action_pressed("jump"):
		player.velocity.y = player.MAX_JUMP_VELOCITY
		player.stamina -= 2
		travel("fall")


func physics_process(_delta: float) -> void:
	var climb = Input.get_axis("move_down_ladder", "move_up_ladder")
	if climb:
		player.velocity.y = climb * -50
		player.anim_state_m.travel("climb")
		if player.velocity.y > 0:
			player.global_position.y += 1
	else:
		player.velocity.y = move_toward(player.velocity.y, 0, 50)
		player.anim_state_m.travel("climb_idle")

	player.anim_tree["parameters/speed/scale"] = climb

	if !player.on_ladder:
		travel("default")
	if player.velocity.x != 0:
		travel("default")

	player.move_and_slide()


func leave() -> void:
	player.request_interaction_visible(false)
	player.on_ladder = false
