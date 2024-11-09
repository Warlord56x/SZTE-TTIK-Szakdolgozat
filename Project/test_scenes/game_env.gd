extends Node

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var background_music: AudioStreamPlayer = $BackgroundMusic


func _ready() -> void:
	start_bg_music()


func start_bg_music() -> void:
	await get_tree().create_timer(0.2).timeout
	background_music.play()


func set_blur(on: bool, time: float = 0.1) -> void:
	var tween := create_tween()
	if on:
		tween.tween_property(world_environment.environment, "glow_mix", 0.75, time)
	else:
		tween.tween_property(world_environment.environment, "glow_mix", 0.0, time)
