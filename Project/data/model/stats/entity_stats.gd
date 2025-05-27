extends CoreStats
class_name EntityStats


@export_group("Basic stats")
var max_health: int
@export var base_max_health: int = 12

var max_mana: int
@export var base_max_mana: int = 12

var max_stamina: int
@export var base_max_stamina: int = 12


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


func set_vitalaity(v: int) -> void:
	vitality = v
	max_health = diminishing_return(base_max_health, vitality)


func set_strength(s: int) -> void:
	strength = s


func set_dexterity(d: int) -> void:
	dexterity = d
	max_stamina = diminishing_return(base_max_stamina, dexterity)


func set_intelligence(i: int) -> void:
	intelligence = i
	max_mana = diminishing_return(base_max_mana, intelligence)


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
