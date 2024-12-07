extends Control
class_name CampMenu

@onready var camp_name: Label = %CampName
@onready var blacksmith: Button = %Blacksmith
@onready var menu: Menu = %CMenu
@onready var blacksmith_menu: Menu = %BlacksmithMenu

var player: Player = null


func _ready() -> void:
	# Must wait til the nodes initialize
	await get_tree().create_timer(0.1).timeout
	var camps := get_tree().get_nodes_in_group("Camp")
	for camp: Camp in camps:
		camp._interact.connect(camp_menu_controller)


func camp_menu_controller(b: bool, camp: Camp = null) -> void:
	if b:
		camp_name.text = camp.camp_name
		player = camp.player
		blacksmith_menu.player = player
		blacksmith.disabled = not camp.anvil
		menu.open()
	else:
		menu.close()
		blacksmith_menu.close()


func player_rest(_player: Player = player) -> void:
	_player.health = _player.max_health
	_player.mana = _player.max_mana
	_player.stamina = _player.max_stamina


func _on_rest_button_pressed() -> void:
	SaveManager.save_game()
	GameEnv.respawn_enemies()


func _on_blacksmith_pressed() -> void:
	if not blacksmith_menu.visible:
		blacksmith_menu.open()
	else:
		blacksmith_menu.close()
