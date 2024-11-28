extends State
class_name StateInteract

@onready var player: Player = owner as Player


func enter() -> void:
	player.velocity = Vector2.ZERO
	player.anim_tree["parameters/speed/scale"] = 1
	player.anim_state_m.travel("interact")
	await player.anim_tree.animation_finished
	player.anim_state_m.travel("idle")
	#travel("default")


func physics_process(_delta: float) -> void:
	player.move_and_slide()


func leave() -> void:
	player.anim_tree["parameters/speed/scale"] = 1
	if player.anim_state_m.get_current_node() == "interact":
		await player.anim_tree.animation_finished
	player.velocity = Vector2.ZERO
