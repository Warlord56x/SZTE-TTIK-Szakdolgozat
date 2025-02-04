@tool
extends Control
class_name Heart

@export var heart: AnimatedSprite2D = null

@export_range(0, 4) var current: int = 4:
	set = set_current


func _ready() -> void:
	if not heart:
		var children = get_children()
		if not children.is_empty():
			heart = children[0]
		else:
			printerr("This node can't work without an AnimatedSprite2D child.")
		return

	if custom_minimum_size == Vector2.ZERO:
		var first_frame = heart.sprite_frames.get_frame_texture("default", 0)
		var first_frame_size = first_frame.get_size() * 2
		custom_minimum_size = first_frame_size
	set_current(4)
	appear_effect()


func appear_effect() -> void:
	var tween := create_tween()
	heart.modulate.a = 0
	tween.tween_property(heart, "modulate:a", 1, 0.3)
	await tween.finished


func disappear_effect() -> void:
	var tween := create_tween()
	heart.modulate.a = 1
	tween.tween_property(heart, "modulate:a", 0, 0.3)
	await tween.finished


func kill_heart() -> void:
	await disappear_effect()
	queue_free()


func set_current(h : int) -> void:
	current = h
	if heart:
		heart.frame = h + 1


func set_null() -> void:
	if heart:
		heart.frame = 0


func set_full() -> void:
	if heart:
		heart.frame = heart.sprite_frames.get_frame_count("default") - 1
