extends Enemy
class_name Boss

@onready var boss: Boss = owner as Boss
@onready var chase_timer := $ChaseTimer


func physics_process(delta: float) -> void:
	if velocity:
		if target:
			move_direction = sign(target.global_position.x - global_position.x)
		else:
			move_direction = sign(velocity.x)

	sprite.flip_h = move_direction < 0


func _on_detect_range_body_entered(body : Node2D) -> void:
	if body is Player and ai:
		target = body
		state_machine.travel("Chase")
