@tool
extends Control

enum JOY_BUTTONS {
	BUTTON_A,
	BUTTON_B,
	BUTTON_X,
	BUTTON_Y,
	DPAD_LEFT,
	DPAD_RIGHT
}

@onready var button: AnimatedSprite2D = $Anim

@export var action: InputEventAction
@export var joypad_button: JOY_BUTTONS:
	set(jpb):
		if !is_node_ready():
			await ready
		joypad_button = jpb
		button.animation = (JOY_BUTTONS.find_key(jpb) as String).to_lower()


func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed(action.action):
		button.frame = 1
	if event.is_action_released(action.action):
		button.frame = 0
