extends CoreStats
class_name ItemStats

@export var item_scale: Scale


func met(stats: EntityStats) -> bool:
	var vit_met := stats.vitality >= vitality
	var str_met := stats.strength >= strength
	var dex_met := stats.dexterity >= dexterity
	var int_met := stats.intelligence >= intelligence
	
	return vit_met && str_met && dex_met && int_met
