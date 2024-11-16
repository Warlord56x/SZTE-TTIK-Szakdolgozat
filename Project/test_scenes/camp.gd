extends InteractionArea
class_name Camp


@onready var camp_menu: VBoxContainer = $CampMenu

var active: bool = false
static var i := 0


func activate() -> void:
	active = true


func deactivate() -> void:
	active = false


func interact(player: Player = null) -> bool:
	player.camp = self
	camp_menu.visible = true
	camp_menu.get_child(0).grab_focus()
	GameEnv.input_process = false
	return interactable


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		interaction_done.emit()
		GameEnv.input_process = true
		camp_menu.visible = false


func _on_rest_button_pressed() -> void:
	SaveManager.save_game(str(i))
	i += 1
