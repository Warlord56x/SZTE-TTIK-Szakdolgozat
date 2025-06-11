extends Enemy
class_name Bat


@onready var chase_timer: Timer = $ChaseTimer


func _ready() -> void:
	super._ready()
	hitbox.hit_callback = knock_back.bind(global_position, 0.3)


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player and ai:
		target = body
		state_machine.travel("Chase")


func _on_detect_range_body_exited(body: Node2D) -> void:
	if body is Player and ai:
		target = null
		chase_timer.start()
