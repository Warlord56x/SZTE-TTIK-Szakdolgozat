extends PanelContainer

const COIN := preload("res://assets/data/items/coin.tres")

@onready var stat_vitality: StatIncreaseSpinner = %StatVitality
@onready var stat_strength: StatIncreaseSpinner = %StatStrength
@onready var stat_dexterity: StatIncreaseSpinner = %StatDexterity
@onready var stat_intelligence: StatIncreaseSpinner = %StatIntelligence

@onready var stat_health: StatIncreaseSpinner = %StatHealth
@onready var stat_mana: StatIncreaseSpinner = %StatMana
@onready var stat_stamina: StatIncreaseSpinner = %StatStamina

@onready var level_info: StatIncreaseSpinner = %LevelInfo
@onready var coin_info: StatIncreaseSpinner = %CoinInfo
@onready var cost_info: Label = %CostInfo

@onready var new_stats_display: Label = %NewStatsDisplay

var player: Player = null

var new_stats: EntityStats = null

var player_coins: Item
var coin_cost: int = 0


func reset_level_window() -> void:
	if not player:
		return
	level_info.current_stat = player.stats.level

	stat_vitality.current_stat = player.stats.vitality
	stat_strength.current_stat = player.stats.strength
	stat_dexterity.current_stat = player.stats.dexterity
	stat_intelligence.current_stat = player.stats.intelligence

	new_stats = player.stats.duplicate()


func update_level_window() -> void:
	if not player:
		return
	level_info.next_stat = new_stats.level

	var coin_amount := 0
	var coin_index := player.inventory.find_item(COIN)
	if coin_index != -1:
		player_coins = player.inventory.get_item(coin_index)
		coin_amount = player_coins.stack
	coin_cost = player.stats.calc_multi_lvl_up_coin_cost(new_stats.level)
	var cost := player.stats.calc_next_lvl_up_coin_cost(new_stats.level)
	coin_info.current_stat = coin_amount
	coin_info.next_stat = coin_amount - coin_cost
	cost_info.text = str(cost)

	var lock = coin_info.next_stat - player.stats.calc_next_lvl_up_coin_cost(new_stats.level, 2)
	lock = lock < 0

	stat_vitality.lock = lock
	stat_strength.lock = lock
	stat_dexterity.lock = lock
	stat_intelligence.lock = lock
	coin_info.manage_error(lock)
	cost_info.label_settings.font_color = Colors.ERROR_COLOR if lock else Colors.DEFAULT_FONT_COLOR

	new_stats_display.text = str(new_stats)

	update_basic_stats()


func update_basic_stats() -> void:
	stat_health.current_stat = player.stats.max_health
	stat_mana.current_stat = player.stats.max_mana
	stat_stamina.current_stat = player.stats.max_stamina
	
	stat_health.next_stat = new_stats.max_health
	stat_mana.next_stat = new_stats.max_mana
	stat_stamina.next_stat = new_stats.max_stamina


func _on_stat_vitality_next_stat_changed(stat: int) -> void:
	new_stats.level += stat - new_stats.vitality
	new_stats.vitality = stat
	update_level_window()


func _on_stat_strength_next_stat_changed(stat: int) -> void:
	new_stats.level += stat - new_stats.strength
	new_stats.strength = stat
	update_level_window()


func _on_stat_dexterity_next_stat_changed(stat: int) -> void:
	new_stats.level += stat - new_stats.dexterity
	new_stats.dexterity = stat
	update_level_window()


func _on_stat_intelligence_next_stat_changed(stat: int) -> void:
	new_stats.level += stat - new_stats.intelligence
	new_stats.intelligence = stat
	update_level_window()


func _on_visibility_changed() -> void:
	reset_level_window()
	update_level_window()


func _on_level_up_button_pressed() -> void:
	player.stats = new_stats
	if player_coins.stack - coin_cost >= 0:
		player_coins.stack -= coin_cost
	reset_level_window()
	update_level_window()
