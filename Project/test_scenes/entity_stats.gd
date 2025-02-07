extends Resource
class_name EntityStats


@export var level: int = 1:
	set = set_level

@export_group("Basic stats")
var max_health: int
@export var base_max_health: int = 12

var max_mana: int
@export var base_max_mana: int = 12

var max_stamina: int
@export var base_max_stamina: int = 12

@export_group("Core Stats")
@export var vitality: int = 10:
	set = set_vitalaity
@export var strength: int = 10:
	set = set_strength
@export var dexterity: int = 10:
	set = set_dexterity
@export var intelligence: int = 10:
	set = set_intelligence

signal level_changed(new_level: int)
signal stat_changed(stat: String, new_value: int)


func _init(
		lvl: int = 1,
		health: int = 12,
		mana: int = 12,
		stamina: int = 12,
		v: int = 10,
		s: int = 10,
		d: int = 10,
		i: int = 10,
	) -> void:

	base_max_health = health
	base_max_mana = mana
	base_max_stamina = stamina

	max_health = health
	max_mana = mana
	max_stamina = stamina

	vitality = v
	strength = s
	dexterity = d
	intelligence = i

	level = lvl


func diminishing_return(base: int, stat: int) -> int:
	var max_value = 60
	var scaling_factor = 20.0
	var raw_max = base + (max_value - base) * (stat / (stat + scaling_factor))
	return raw_max
	#return int(round(raw_max / 4.0)) * 4


func calc_next_lvl_up_coin_cost(new_level: int, next: int = 1) -> int:
	var diff = next + abs(level - new_level)
	if diff == 0:
		return diff
	return (level + diff) * 3 + 6


func calc_multi_lvl_up_coin_cost(new_level: int) -> int:
	var cost = 0
	for lvl in range(level, new_level):
		cost += calc_next_lvl_up_coin_cost(lvl)
	return cost


func set_level(lvl: int) -> void:
	level = lvl
	level_changed.emit(level)


func set_vitalaity(v: int) -> void:
	#level += v - vitality
	vitality = v
	max_health = diminishing_return(base_max_health, vitality)
	stat_changed.emit("vit", vitality)


func set_strength(s: int) -> void:
	#level += s - strength
	strength = s
	stat_changed.emit("str", strength)


func set_dexterity(d: int) -> void:
	#level += d - dexterity
	dexterity = d
	max_stamina = diminishing_return(base_max_stamina, dexterity)
	stat_changed.emit("dex", dexterity)


func set_intelligence(i: int) -> void:
	#level += i - intelligence
	intelligence = i
	max_mana = diminishing_return(base_max_mana, intelligence)
	stat_changed.emit("int", intelligence)


func _to_string() -> String:
	var result = "Stats:\n"
	result += "-----------------\n"
	result += "Level: " + str(level)+ "\n"
	result += "Health: " + str(max_health)+ "\n"
	result += "Mana: " + str(max_mana) + "\n"
	result += "Stamina: " + str(max_stamina) + "\n\n"
	result += "Attributes:\n"
	result += "  Vitality: " + str(vitality) + "\n"
	result += "  Strength: " + str(strength) + "\n"
	result += "  Dexterity: " + str(dexterity) + "\n"
	result += "  Intelligence: " + str(intelligence) + "\n"
	return result
