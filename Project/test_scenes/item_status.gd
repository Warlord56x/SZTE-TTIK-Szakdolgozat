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

@onready var item_name: Label = %ItemName
@onready var description: Label = %Description

@onready var stat_level: StatDisplay = %StatLevel
@onready var weapon_stats: VBoxContainer = %WeaponStats

@export var item: Item:
	set = set_item


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
		return
	stat_level.visible = true
	weapon_stats.visible = true
	updata_values()


func updata_values() -> void:
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
