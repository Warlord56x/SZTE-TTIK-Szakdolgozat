extends InteractionArea
class_name Camp


var active: bool = false

signal _interact(b: bool)


func activate() -> void:
	active = true


func deactivate() -> void:
	active = false


func interact(player: Player = null) -> bool:
	player.camp = self
	_interact.emit(true)
	GameEnv.input_process = false
	return interactable


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if active:
			interaction_done.emit()
			_interact.emit(false)
			GameEnv.input_process = true
			get_window().set_input_as_handled()
			deactivate()
