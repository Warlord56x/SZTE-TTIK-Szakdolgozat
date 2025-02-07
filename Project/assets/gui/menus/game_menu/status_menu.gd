extends Menu
class_name StatusMenu

@onready var stat_vitality: StatDisplay = %StatVitality
@onready var stat_strength: StatDisplay = %StatStrength
@onready var stat_dexterity: StatDisplay = %StatDexterity
@onready var stat_intelligence: StatDisplay = %StatIntelligence

@onready var stat_health: StatDisplay = %StatHealth
@onready var stat_mana: StatDisplay = %StatMana
@onready var stat_stamina: StatDisplay = %StatStamina

@onready var player: Player
var stats: EntityStats


func vis_changed() -> void:
	super.vis_changed()
	update_menu()


func update_menu() -> void:
	player = get_tree().get_first_node_in_group("Player")
	stats = player.stats

	stat_vitality.stat = stats.vitality
	stat_strength.stat = stats.strength
	stat_dexterity.stat = stats.dexterity
	stat_intelligence.stat = stats.intelligence

	stat_health.stat = stats.max_health
	stat_mana.stat = stats.max_mana
	stat_stamina.stat = stats.max_stamina
