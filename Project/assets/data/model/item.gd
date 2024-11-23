extends Resource
class_name Item

@export var name: String
@export var icon: Texture2D

@export var stack: int:
	set(s):
		stack = s
		stack_changed.emit()
@export var stack_size: int

signal stack_changed
