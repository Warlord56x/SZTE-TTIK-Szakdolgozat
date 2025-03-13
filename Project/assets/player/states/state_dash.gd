extends State
class_name StateDash

@onready var player: Player = owner as Player
@onready var col_layer: int = player.collision_layer
@onready var col_mask: int = player.collision_mask


func enter() -> void:
	if player.has_node("HurtBox"):
		player.get_node("HurtBox").set_deferred("monitoring", false)
	#player.collision_mask = 8
	#player.collision_layer = 8
	player.anim_state_m.travel("dash")
	player.anim_tree["parameters/speed/scale"] = 1
	await get_tree().create_timer(0.2).timeout
	travel("fall")


func physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO
	player.velocity.x = player.move_direction.x * player.SPEED * 2
	player.move_and_slide()


func leave() -> void:
	if player.has_node("HurtBox"):
		player.get_node("HurtBox").set_deferred("monitoring", true)
	#player.collision_mask = col_mask
	#player.collision_layer = col_layer
	player.dash_count += 1
	player.stamina -= 2
