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


func diminishing_return(base: int, stat: int) -> int:
	var max_value = 60
	var scaling_factor = 20.0
	var raw_max = base + (max_value - base) * (stat / (stat + scaling_factor))
	return raw_max
	# TODO do something for the hearts to
	# be visible when stat is not a multiple of 4
	# DO NOT force the multiple of 4,
	# makes diminishing feel too small or too much
	#return int(round(raw_max / 4.0)) * 4


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
