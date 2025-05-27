extends Control
class_name SaveElement


@export var button_group: ButtonGroup
@onready var screen_shot: TextureRect = %ScreenShot
@onready var time_label: Label = %TimeLabel

var time: String
var test: String
var slot: SaveSlot

signal pressed(s: SaveSlot)


func _ready() -> void:
	time_label.text = time
	%Button.button_group = button_group
	%NameLabel.text = test
	if slot:
		pass


func _on_button_pressed() -> void:
	pressed.emit(slot)
