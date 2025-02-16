extends Menu
class_name ItemStatus


@onready var stat_vit: StatDisplay = %StatVit
@onready var stat_str: StatDisplay = %StatStr
@onready var stat_dex: StatDisplay = %StatDex
@onready var stat_int: StatDisplay = %StatInt

@onready var stat_vit_scale: StatDisplay = %StatVitScale
@onready var stat_str_scale: StatDisplay = %StatStrScale
@onready var stat_dex_scale: StatDisplay = %StatDexScale
@onready var stat_int_scale: StatDisplay = %StatIntScale
@onready var warning: Label = %Warning

@onready var item_name: Label = %ItemName
@onready var description: Label = %Description

@onready var stat_level: StatDisplay = %StatLevel
@onready var weapon_stats: VBoxContainer = %WeaponStats

@export var item: Item:
	set = set_item


func get_player() -> Player:
	return get_tree().get_first_node_in_group("Player")


func set_item(it: Item) -> void:
	item = it
	if not item:
		return
	if not is_node_ready():
		await ready
	reset_values()
	item_name.text = item.name
	description.text = item.description
	if item is not WeaponItem:
		stat_level.visible = false
		weapon_stats.visible = false
		warning.visible = false
		%Damages.visible = false
		return
	stat_level.visible = true
	weapon_stats.visible = true
	updata_values()
	update_display()


func updata_values() -> void:
	warning.visible = false
	var weapon := item as WeaponItem
	stat_level.stat = item.item_stats.level

	stat_vit.stat = weapon.item_stats.vitality
	stat_str.stat = weapon.item_stats.strength
	stat_dex.stat = weapon.item_stats.dexterity
	stat_int.stat = weapon.item_stats.intelligence

	stat_vit_scale.stat_scale = weapon.item_stats.item_scale.vitality_scale
	stat_str_scale.stat_scale = weapon.item_stats.item_scale.strength_scale
	stat_dex_scale.stat_scale = weapon.item_stats.item_scale.dexterity_scale
	stat_int_scale.stat_scale = weapon.item_stats.item_scale.intelligence_scale


	if not get_player():
		return
	var calc_damage := weapon.calc_damage(get_player().stats)
	%DamageLabel.text = "%d" % weapon.damage
	%ActualDamageLabel.text = "(%d)" % calc_damage
	warning.visible = not weapon.item_stats.met(get_player().stats)
	warning.text = "Item stat requirements are not met!\nThe item can't be used effectively. (No scaling applied, -40% from damage)"



func update_display() -> void:
	var player := get_player()
	if not get_player():
		return
	var player_stats := player.stats

	var helper := func (n: StatDisplay, c: int):
		n.stat_font_color = Colors.ERROR_COLOR if n.stat > c else Color.WHITE

	helper.call(stat_vit, player_stats.vitality)
	helper.call(stat_str, player_stats.strength)
	helper.call(stat_dex, player_stats.dexterity)
	helper.call(stat_int, player_stats.intelligence)



func reset_values() -> void:
	stat_level.stat = 0
	item_name.text = "No item"
	description.text = "No description"

	stat_vit.stat = 0
	stat_str.stat = 0
	stat_dex.stat = 0
	stat_int.stat = 0

	stat_vit_scale.stat = 0
	stat_str_scale.stat = 0
	stat_dex_scale.stat = 0
	stat_int_scale.stat = 0
