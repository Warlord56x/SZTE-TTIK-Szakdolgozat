extends State
class_name StateDash

@onready var player: Player = owner as Player


func enter() -> void:
	player.collision_mask = 8
	player.collision_layer = 8
	player.anim_state_m.travel("dash")
	player.anim_tree["parameters/speed/scale"] = 1
	await get_tree().create_timer(0.2).timeout
	travel("fall")


func physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.velocity.x = player.move_direction.x * player.SPEED * 2
	player.move_and_slide()


func leave() -> void:
	player.collision_mask = 17
	player.collision_layer = 1
	player.dash_count += 1
	player.stamina -= 2
