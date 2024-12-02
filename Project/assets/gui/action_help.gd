@tool
extends Control

#enum JOY_BUTTONS {
	#BUTTON_A,
	#BUTTON_B,
	#BUTTON_X,
	#BUTTON_Y,
	#DPAD_LEFT,
	#DPAD_RIGHT
#}

@onready var special: bool = false
@onready var special_letters: AnimatedSprite2D = $SpecialLetters

@onready var button: AnimatedSprite2D = $Anim
@onready var key: Label = $Label
@onready var baseAnim: AnimatedSprite2D = $BaseButton

@export var action: InputEventAction
@export var joypad_button: JoyButton= JOY_BUTTON_A:
	set = set_joy_button


func set_joy_button(jpb: JoyButton) -> void:
		joypad_button = jpb
		if Engine.is_editor_hint() and is_node_ready():
			refresh_label()


func _ready() -> void:
	refresh_label()


func refresh_label() -> void:
	button.animation = str(joypad_button)
	if key:
		key.text = action.as_text().left(1)

	if action.as_text().containsn("shift"):
		special = true
		special_letters.visible = true
		special_letters.animation = "shift"
	if action.as_text().containsn("mouse"):
		special = true
		special_letters.visible = true
		special_letters.animation = "click"


func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		button.visible = false
		key.visible = not special
		$SpecialLetters.visible = special
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		button.visible = true
		key.visible = false

	if event.is_action_pressed(action.action):
		button.frame = 1
		baseAnim.frame = 1
		key.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		$SpecialLetters.offset.y = 5
	if event.is_action_released(action.action):
		button.frame = 0
		baseAnim.frame = 0
		$SpecialLetters.offset.y = 4
		key.vertical_alignment = VERTICAL_ALIGNMENT_TOP
