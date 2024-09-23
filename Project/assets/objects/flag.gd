extends Area2D

var is_on : bool = false

func _on_body_entered(body : Node2D) -> void:
	if body is Player and !is_on:
		activate()
		body.checkpoint = self


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "default" and is_on:
		$AnimatedSprite2D.play("active")


func activate() -> void:
	$AnimatedSprite2D.play("default")
	is_on = true


func deactivate() -> void:
	$AnimatedSprite2D.play_backwards("default")
	is_on = false
