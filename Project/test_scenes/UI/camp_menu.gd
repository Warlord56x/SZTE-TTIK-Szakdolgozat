extends MarginContainer
class_name ClassMenu


var i := 0


func _init() -> void:
	visible = false


func _ready() -> void:
	# Must wait til the nodes initialize
	await get_tree().create_timer(0.1).timeout
	var camps := get_tree().get_nodes_in_group("Camp")
	for camp: Camp in camps:
		camp._interact.connect(camp_menu_controller)


func camp_menu_controller(b: bool) -> void:
	if b:
		visible = true
		%CampMenu.get_child(0).grab_focus()
	else:
		visible = false


func _on_rest_button_pressed() -> void:
	SaveManager.save_game("")
	GameEnv.respawn_enemies()
	i += 1
