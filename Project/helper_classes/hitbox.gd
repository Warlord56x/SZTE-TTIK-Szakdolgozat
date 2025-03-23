@tool
extends Area2D
class_name Hitbox

@export var parent_ref: Node2D = owner
@export var damage: int = 0
@export var knock_back_strength: float = 0

@export var sound_on_hit: AudioStreamPlayer2D
@export var hit_callback: Callable


func _init() -> void:
	input_pickable = false
	collision_layer = 64
	collision_mask = 0
	monitoring = false
	monitorable = true
