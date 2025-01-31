class_name EntityStats


var max_health: int
var base_max_health: int:
	set = set_base_max_health

var vitality: int:
	set = set_vitalaity
var strength: int:
	set = set_strength
var dexterity: int:
	set = set_dexterity
var intelligence: int:
	set = set_intelligence


func _init(
		h: int = 20,
		v: int = 10,
		s: int = 10,
		d: int = 10,
		i: int = 10
	) -> void:

	base_max_health = h
	max_health = h
	vitality = v
	strength = s
	dexterity = d
	intelligence = i


func set_base_max_health(h: int) -> void:
	base_max_health = h


func set_vitalaity(v: int) -> void:
	vitality = v
	max_health = base_max_health + (vitality * 4)


func set_strength(s: int) -> void:
	strength = s


func set_dexterity(d: int) -> void:
	dexterity = d


func set_intelligence(i: int) -> void:
	intelligence = i


func _to_string() -> String:
	return "[Stats] max_health: %d, base_max_health: %d, vitality: %d, strength: %d, dexterity: %d, intelligence: %d" % [
		max_health, base_max_health, vitality, strength, dexterity, intelligence
	]
