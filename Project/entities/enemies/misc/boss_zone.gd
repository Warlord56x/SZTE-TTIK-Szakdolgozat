extends Area2D
class_name BossZone


@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		canvas_layer.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		canvas_layer.visible = false
