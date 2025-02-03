extends Control
class_name CampMenu

@onready var camp_name: Label = %CampName
@onready var blacksmith: Button = %Blacksmith
@onready var menu: Menu = %MainCampMenu
@onready var blacksmith_menu: Menu = %CampChildMenu
@onready var travel: PanelContainer = %Travel
@onready var level_up: PanelContainer = %LevelUp

var player: Player = null


func _ready() -> void:
	# Avoid blocking ready from occuring.
	_init_camps.call_deferred()


func _init_camps() -> void:
	# Must wait til the nodes initialize
	# The first physics frame should be perfect for this
	await get_tree().physics_frame
	
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
		level_up.player = player
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

	player_.recover()

	await GameEnv.fade_step_wait
	GameEnv.load_icon(false)


func _on_rest_button_pressed() -> void:
	player_rest()
	SaveManager.save_game()
	GameEnv.respawn_enemies()


func _on_blacksmith_pressed() -> void:
	if not blacksmith_menu.visible:
		blacksmith_menu.open()
		blacksmith_menu.current_tab = 0
	else:
		if blacksmith_menu.current_tab == 0:
			blacksmith_menu.close()
		else:
			blacksmith_menu.current_tab = 0


func _on_travel_pressed() -> void:
	if not blacksmith_menu.visible:
		blacksmith_menu.open()
		blacksmith_menu.current_tab = 2
	else:
		if blacksmith_menu.current_tab == 2:
			blacksmith_menu.close()
		else:
			blacksmith_menu.current_tab = 2


func _on_travel_travel(camp: Camp) -> void:
	reset_menu_state(camp)


func _on_level_up_pressed() -> void:
	if not blacksmith_menu.visible:
		blacksmith_menu.open()
		blacksmith_menu.current_tab = 1
	else:
		if blacksmith_menu.current_tab == 1:
			blacksmith_menu.close()
		else:
			blacksmith_menu.current_tab = 1
