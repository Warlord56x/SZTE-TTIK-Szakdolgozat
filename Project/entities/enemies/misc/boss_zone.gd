extends Area2D
class_name BossZone


@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var col_shape: CollisionShape2D = $CollisionShape2D
@onready var progress_bar: ProgressBar = $CanvasLayer/Control/ProgressBar


func set_up_zone(min_value: int, max_value: int) -> void:
	progress_bar.min_value = min_value
	progress_bar.max_value = max_value
	progress_bar.value = max_value


func update_hp_progress(value: int) -> void:
	progress_bar.value = value


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		canvas_layer.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		canvas_layer.visible = false


func get_rect() -> Rect2:
	return col_shape.shape.get_rect()
