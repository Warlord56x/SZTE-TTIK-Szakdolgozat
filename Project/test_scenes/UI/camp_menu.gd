extends Control
class_name CampMenu

@onready var camp_name: Label = %CampName
@onready var blacksmith: Button = %Blacksmith
@onready var menu: Menu = %CMenu
@onready var blacksmith_menu: Menu = %BlacksmithMenu
@onready var travel: PanelContainer = $MenuContainer/BlacksmithMenu/TabContainer/Travel

var player: Player = null


func _ready() -> void:
	# Must wait til the nodes initialize
	await get_tree().create_timer(0.1).timeout
	var camps := get_tree().get_nodes_in_group("Camp")
	for camp: Camp in camps:
		camp._interact.connect(camp_menu_controller)


func camp_menu_controller(b: bool, camp: Camp = null) -> void:
	if b and camp:
		camp_name.text = camp.camp_name
		player = camp.player
		blacksmith_menu.player = player
		reset_menu_state(camp)
		travel.player = player
		menu.open()
	else:
		menu.close()
		blacksmith_menu.close()


func reset_menu_state(camp: Camp) -> void:
	camp_name.text = camp.camp_name
	blacksmith.disabled = not camp.anvil
	blacksmith_menu.disable_tab(0, not camp.anvil)


func player_rest(player_: Player = player) -> void:
	GameEnv.fade_in_out(0.5, "Resting...")
	GameEnv.load_icon(true)
	await GameEnv.fade_step_in

	player_.health = player_.max_health
	player_.mana = player_.max_mana
	player_.stamina = player_.max_stamina

	await GameEnv.fade_step_wait
	GameEnv.load_icon(false)


func _on_rest_button_pressed() -> void:
	player_rest()
	SaveManager.save_game()
	GameEnv.respawn_enemies()


func _on_blacksmith_pressed() -> void:
	if not blacksmith_menu.visible:
		blacksmith_menu.open()
		blacksmith_menu.tab(0)
	else:
		if blacksmith_menu.current_tab == 0:
			blacksmith_menu.close()
		else:
			blacksmith_menu.current_tab = 0


func _on_travel_pressed() -> void:
	if not blacksmith_menu.visible:
		blacksmith_menu.open()
		blacksmith_menu.tab(2)
	else:
		if blacksmith_menu.current_tab == 2:
			blacksmith_menu.close()
		else:
			blacksmith_menu.current_tab = 2


func _on_travel_travel(camp: Camp) -> void:
	reset_menu_state(camp)
