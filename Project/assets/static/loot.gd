extends Node
class_name Loot

static var rng : RandomNumberGenerator = RandomNumberGenerator.new()

static func _static_init() -> void:
	rng.randomize()

static func get_arrows(_min : int, _max : int) -> int:
	rng.randomize()
	return rng.randi_range(_min, _max)
