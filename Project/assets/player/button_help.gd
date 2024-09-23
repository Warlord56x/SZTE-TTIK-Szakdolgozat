extends Control

enum {
	RIGHT,
	LEFT,
}


func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("wheel_plus"):
		var button : AnimatedSprite2D = get_child(RIGHT)
		button.frame = 1
	if event.is_action_pressed("wheel_minus"):
		var button : AnimatedSprite2D = get_child(LEFT)
		button.frame = 1

	if event.is_action_released("wheel_plus"):
		var button : AnimatedSprite2D = get_child(RIGHT)
		button.frame = 0
	if event.is_action_released("wheel_minus"):
		var button : AnimatedSprite2D = get_child(LEFT)
		button.frame = 0
