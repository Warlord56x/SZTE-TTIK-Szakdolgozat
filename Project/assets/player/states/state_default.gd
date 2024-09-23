extends State
class_name StateDefault

@onready var player: Player = owner as Player


func enter() -> void:
	pass


func physics_process(_delta: float) -> void:
	player.default_process(player.input_direction)
	player.default_animations(player.input_direction)

	if not player.is_on_floor():
		travel("Fall")
	player.move_and_slide()


func leave() -> void:
	pass
