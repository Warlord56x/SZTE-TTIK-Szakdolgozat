extends Node


const MAIN_MENU := preload("res://test_scenes/UI/main_menu.tscn")

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var effect: ShaderMaterial = $ScreenEffectLayer/Control/Effect.material as ShaderMaterial
@onready var label: Label = $ScreenEffectLayer/Control/Label

var input_process: bool = true

signal fade_step1
signal fade_step2
signal fade_step3


func slow_time(slow_for: float, slow: float) -> void:
	Engine.time_scale = slow
	await get_tree().create_timer(slow_for * slow).timeout
	Engine.time_scale = 1.0


func _ready() -> void:
	start_bg_music()


func fade_in_out(fade_for: float, label_text: String = "") -> void:
	label.text = label_text

	var tween := get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_method(_progress, 0.0, 1.0, 0.5)

	tween.tween_method(_progress, 1.0, 1.0, fade_for)

	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_method(_progress, 1.0, 0.0, 0.5)

	await tween.step_finished
	fade_step1.emit()
	await tween.step_finished
	fade_step2.emit()
	await tween.step_finished
	fade_step3.emit()


func _progress(f: float) -> void:
	effect.set_shader_parameter("progress", f)


func start_bg_music() -> void:
	await get_tree().create_timer(0.2).timeout
	background_music.play()


func set_blur(on: bool, time: float = 0.1) -> void:
	var tween := create_tween()
	if on:
		tween.tween_property(world_environment.environment, "glow_mix", 0.75, time)
	else:
		tween.tween_property(world_environment.environment, "glow_mix", 0.0, time)
