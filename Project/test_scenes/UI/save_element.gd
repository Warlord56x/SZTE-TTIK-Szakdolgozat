extends Control
class_name SaveElement


@export var button_group: ButtonGroup
@onready var screen_shot: TextureRect = %ScreenShot
@onready var time_label: Label = %TimeLabel

var time: String


func _ready() -> void:
	time_label.text = time
	%Button.button_group = button_group
