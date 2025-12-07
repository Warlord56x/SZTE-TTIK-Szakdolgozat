extends Node


func _ready() -> void:
	initial_case()
	print("-----------------------\n")
	low_level_case()
	print("-----------------------\n")
	high_level_case()


func initial_case() -> void:
	var test_entity_stat := EntityStats.new()
	print(test_entity_stat)

	assert(test_entity_stat.base_max_health == 12, "Base max health should be 12")
	assert(test_entity_stat.base_max_mana == 12, "Base max mana should be 12")
	assert(test_entity_stat.base_max_stamina == 12, "Base max stamina should be 12")

	assert(test_entity_stat.vitality == 10, "Base stat should be 10")
	assert(test_entity_stat.strength == 10, "Base stat should be 10")
	assert(test_entity_stat.dexterity == 10, "Base stat should be 10")
	assert(test_entity_stat.intelligence == 10, "Base stat should be 10")

	assert(test_entity_stat.max_health == 28, "Max should be 28")
	assert(test_entity_stat.max_mana == 28, "Max should be 28")
	assert(test_entity_stat.max_stamina == 28, "Max should be 28")

	print("Initial test: Passed")


func low_level_case() -> void:
	var test_entity_stat := EntityStats.new()
	test_entity_stat.set_level(5)
	test_entity_stat.set_vitalaity(12)
	test_entity_stat.set_strength(12)
	test_entity_stat.set_dexterity(10)
	test_entity_stat.set_intelligence(11)
	print(test_entity_stat)

	assert(test_entity_stat.level == 5, "Expected: %d, got %d" % [test_entity_stat.level, 5])
	assert(test_entity_stat.vitality == 12, "Expected: %d, got %d" % [test_entity_stat.level, 5])
	assert(test_entity_stat.strength == 12, "Expected: %d, got %d" % [test_entity_stat.level, 5])
	assert(test_entity_stat.dexterity == 10, "Expected: %d, got %d" % [test_entity_stat.level, 5])
	assert(test_entity_stat.intelligence == 11, "Expected: %d, got %d" % [test_entity_stat.level, 5])

	assert(test_entity_stat.max_health == 30, "Expected: %d, got %d" % [test_entity_stat.level, 5])
	assert(test_entity_stat.max_mana == 29, "Expected: %d, got %d" % [test_entity_stat.level, 5])
	assert(test_entity_stat.max_stamina == 28, "Expected: %d, got %d" % [test_entity_stat.level, 5])

	assert(test_entity_stat.calc_multi_lvl_up_coin_cost(6) == 24)
	assert(test_entity_stat.calc_multi_lvl_up_coin_cost(40) == 2625)

	print("Low level test: Passed")


func high_level_case() -> void:
	var test_entity_stat := EntityStats.new()
	test_entity_stat.set_level(41)
	test_entity_stat.set_vitalaity(20)
	test_entity_stat.set_strength(20)
	test_entity_stat.set_dexterity(20)
	test_entity_stat.set_intelligence(20)
	print(test_entity_stat)

	assert(test_entity_stat.level == 41)
	assert(test_entity_stat.vitality == 20)
	assert(test_entity_stat.strength == 20)
	assert(test_entity_stat.dexterity == 20)
	assert(test_entity_stat.intelligence == 20)

	assert(test_entity_stat.max_health == 36)
	assert(test_entity_stat.max_mana == 36)
	assert(test_entity_stat.max_stamina == 36)

	assert(test_entity_stat.calc_multi_lvl_up_coin_cost(42) == 132)
	assert(test_entity_stat.calc_multi_lvl_up_coin_cost(100) == 12921)

	print("High level test: Passed")
