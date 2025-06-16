extends Control
class_name SaveElement


@export var button_group: ButtonGroup
@onready var screen_shot: TextureRect = %ScreenShot
@onready var time_label: Label = %TimeLabel
@onready var name_label: Label = %NameLabel
@onready var error_label: Label = %ErrorLabel

var time: String
var slot_name: String
var slot: SaveSlot

signal pressed(s: SaveSlot)


func _ready() -> void:
	time_label.text = slot.get_saved_at()
	%Button.button_group = button_group
	name_label.text = slot.name
	
	if slot.has_corrupt or slot.saves.is_empty() or slot.all_corrupt:
		error_label.visible = true
	
	if slot.has_corrupt:
		error_label.text = "Contains corrupt/old save data!"
	if slot.saves.is_empty():
		error_label.text = "No saves found in slot! (Possibly corrupt)"
	if slot.all_corrupt:
		error_label.text = "All save files corrupted in slot!"


func _on_button_pressed() -> void:
	pressed.emit(slot)
