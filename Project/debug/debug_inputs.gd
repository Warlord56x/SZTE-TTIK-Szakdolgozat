extends Node
class_name NinDebug

var is_fullscreen : bool = false
@onready var window : Window = get_window()


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("debug_fullscreen"):
		if !is_fullscreen:
			window.set_mode(Window.MODE_FULLSCREEN)
		else:
#			window.reset_size()
			window.set_mode(Window.MODE_WINDOWED)
		is_fullscreen = !is_fullscreen
