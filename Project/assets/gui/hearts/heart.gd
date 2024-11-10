@tool
extends Control
class_name Heart

@export var heart: AnimatedSprite2D = null

@export_range(0, 4) var current: int = 4:
	set = set_current


func _init() -> void:
	if not heart:
		var children = get_children()
		if not children.is_empty():
			heart = children[0]


func _ready() -> void:
	set_current(4)


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
