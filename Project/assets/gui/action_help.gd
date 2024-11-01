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
@onready var key: Label = $Label
@onready var baseAnim: AnimatedSprite2D = $BaseButton

@export var action: InputEventAction
@export var joypad_button: JOY_BUTTONS:
	set(jpb):
		if !is_node_ready():
			await ready
		joypad_button = jpb
		button.animation = (JOY_BUTTONS.find_key(jpb) as String).to_lower()
		key.text = action.as_text().left(1)


func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		button.visible = false
		key.visible = true
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		button.visible = true
		key.visible = false

	if event.is_action_pressed(action.action):
		button.frame = 1
		baseAnim.frame = 1
		key.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if event.is_action_released(action.action):
		button.frame = 0
		baseAnim.frame = 0
		key.vertical_alignment = VERTICAL_ALIGNMENT_TOP
