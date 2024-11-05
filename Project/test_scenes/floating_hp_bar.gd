extends Control
class_name FloatingHpBar

@export var value: float = 0.0:
	set = set_value
@export var min_value: float = 0.0:
	set = set_min
@export var max_value: float = 100.0:
	set = set_max

@onready var bar: TextureProgressBar = $TextureProgressBar

signal value_changed(value: float)

var effect: bool = false


func _ready() -> void:
	modulate.a = 0.0


func set_value(v: float) -> void:
	value = v
	bar.value = v

	if not effect:
		return

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	tween.tween_property(self, "modulate:a", 1.0, 1.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)


func set_min(v: float) -> void:
	min_value = v
	bar.min_value = v


func set_max(v: float) -> void:
	max_value = v
	bar.max_value = v


func _on_texture_progress_bar_value_changed(v: float) -> void:
	value_changed.emit(v)
