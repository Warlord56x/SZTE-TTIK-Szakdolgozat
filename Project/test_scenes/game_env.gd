extends Node

@onready var world_environment: WorldEnvironment = $WorldEnvironment


func set_blur(on: bool, time: float = 0.1) -> void:
	var tween := create_tween()
	if on:
		tween.tween_property(world_environment.environment, "glow_mix", 0.75, time)
	else:
		tween.tween_property(world_environment.environment, "glow_mix", 0.0, time)
