extends Node


const MAIN_MENU := preload("res://test_scenes/UI/main_menu.tscn")

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var effect: ShaderMaterial = $ScreenEffectLayer/Control/Effect.material as ShaderMaterial
@onready var label: Label = $ScreenEffectLayer/Control/Label
@onready var load_icon_sprite: AnimatedSprite2D = $ScreenEffectLayer/Control/Control/LoadIconSprite

var input_process: bool = true

signal fade_step_in
signal fade_step_wait
signal fade_step_out


func slow_time(slow_for: float, slow: float) -> void:
	Engine.time_scale = slow
	await get_tree().create_timer(slow_for * slow).timeout
	Engine.time_scale = 1.0


func _ready() -> void:
	start_bg_music()


func fade_in_out(fade_for: float, label_text: String = "") -> void:
	label.text = label_text

	var tween := get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_method(_progress, 0.0, 1.0, 0.5)

	tween.tween_method(_progress, 1.0, 1.0, fade_for)

	tween.tween_property(label, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_method(_progress, 1.0, 0.0, 0.5)

	await tween.step_finished
	fade_step_in.emit()
	await tween.step_finished
	fade_step_wait.emit()
	await tween.step_finished
	fade_step_out.emit()


func fade_in(label_text: String = "") -> void:
	label.text = label_text

	var tween := get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_method(_progress, 0.0, 1.0, 0.5)

	await tween.finished
	fade_step_in.emit()


func fade_out(label_text: String = "") -> void:
	label.text = label_text

	var tween := get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_method(_progress, 1.0, 0.0, 0.5)

	await tween.finished
	fade_step_out.emit()


func load_icon(on: bool) -> void:
	var tween := create_tween()
	if on:
		tween.tween_property(load_icon_sprite, "modulate:a", 1.0, 0.2)
	else:
		tween.tween_property(load_icon_sprite, "modulate:a", 0.0, 0.2)


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
