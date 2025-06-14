extends Area2D
class_name BossZone


@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		canvas_layer.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		canvas_layer.visible = false


func get_rect() -> Rect2:
	return collision_shape_2d.shape.get_rect()
