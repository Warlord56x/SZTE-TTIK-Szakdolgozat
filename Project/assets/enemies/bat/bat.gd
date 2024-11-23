extends Enemy
class_name Bat


@onready var hitbox: Hitbox = $Hitbox


func ready() -> void:
	hitbox.hit_callback = knock_back.bind(global_position, 0.8)


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player:
		target = body
		state_machine.travel("Chase")
