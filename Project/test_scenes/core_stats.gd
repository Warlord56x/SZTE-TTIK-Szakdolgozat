extends Resource
class_name CoreStats

@export var level: int = 1:
	set = set_level

@export_group("Core Stats")
@export var vitality: int = 10:
	set = set_vitalaity
@export var strength: int = 10:
	set = set_strength
@export var dexterity: int = 10:
	set = set_dexterity
@export var intelligence: int = 10:
	set = set_intelligence


func set_level(lvl: int) -> void:
	level = lvl


func set_vitalaity(v: int) -> void:
	vitality = v


func set_strength(s: int) -> void:
	strength = s


func set_dexterity(d: int) -> void:
	dexterity = d


func set_intelligence(i: int) -> void:
	intelligence = i
