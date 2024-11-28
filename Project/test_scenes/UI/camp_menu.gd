extends MarginContainer
class_name CampMenu

@onready var camp_name: Label = %CampName
@onready var menu: Menu = $Menu

#
#func _init() -> void:
	#visible = false


func _ready() -> void:
	# Must wait til the nodes initialize
	await get_tree().create_timer(0.1).timeout
	var camps := get_tree().get_nodes_in_group("Camp")
	for camp: Camp in camps:
		camp._interact.connect(camp_menu_controller)


func camp_menu_controller(b: bool, camp: Camp = null) -> void:
	if b:
		camp_name.text = camp.camp_name
		#visible = true
		menu.open()
		#%RestButton.grab_focus()
	else:
		menu.close()


func _on_rest_button_pressed() -> void:
	SaveManager.save_game()
	GameEnv.respawn_enemies()
