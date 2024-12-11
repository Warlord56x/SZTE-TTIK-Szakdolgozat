extends Node


const MAIN_MENU := preload("res://assets/gui/menus/main_menu/main_menu.tscn")

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var effect: ShaderMaterial = $ScreenEffectLayer/Control/Effect.material as ShaderMaterial
@onready var label: Label = $ScreenEffectLayer/Control/Label
@onready var load_icon_sprite: AnimatedSprite2D = $ScreenEffectLayer/Control/Control/LoadIconSprite

var input_process: bool = true

var nodes_to_respawn: Array[Dictionary] = []

signal fade_step_in
signal fade_step_wait
signal fade_step_out


func _ready() -> void:
	start_bg_music()


func respawn_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("Respawnable"):
		enemy.death()
	for enemy in nodes_to_respawn:
		var e = load(enemy.filename).instantiate()
		e.global_position = enemy.position
		get_node(enemy.parent).add_child(e)
		e.add_to_group("Respawnable")
		print("respawned 1 enemy")
	nodes_to_respawn.clear()


func slow_time(slow_for: float, slow: float) -> void:
	Engine.time_scale = slow
	await get_tree().create_timer(slow_for * slow).timeout
	Engine.time_scale = 1.0


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
