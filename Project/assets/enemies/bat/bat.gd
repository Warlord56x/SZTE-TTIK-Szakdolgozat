extends Enemy
class_name Bat


@onready var hitbox: Hitbox = $Hitbox


func _ready() -> void:
	super._ready()
	hitbox.hit_callback = knock_back.bind(global_position, 0.3)


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player and ai:
		target = body
		state_machine.travel("Chase")
