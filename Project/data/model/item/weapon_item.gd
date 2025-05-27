extends Item
class_name WeaponItem

@export var damage: int = 1

@export var item_stats: ItemStats


func calc_damage(stats: EntityStats) -> int:
	if item_stats and not item_stats.met(stats):
		return floor(damage * 0.6)
	if not item_stats.item_scale:
		return damage
	var _stats: Array[int] = [
		stats.vitality,
		stats.strength,
		stats.dexterity,
		stats.intelligence
	]
	return item_stats.item_scale.calc_all_scales(damage, _stats)


func _to_string() -> String:
	return str("Weapon: ",name)
