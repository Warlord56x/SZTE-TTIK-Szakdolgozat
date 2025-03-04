extends Resource
class_name Item

@export var name: String
@export var icon: Texture2D
@export_multiline var description: String = ""

@export_storage var stack: int:
	set(s):
		stack = s
		stack_changed.emit()
@export var stack_size: int
@export var cooldown: float
@export var pickup_animation: SpriteFrames

var used: bool = false:
	set(u):
		used = u
		_used.emit(u)

signal _used(u: bool)
signal stack_changed


func _to_string() -> String:
	return str("Item: ",name)
