extends Node


var save_slots: Array[SaveSlot] = [
	SaveSlot.new("0"),
	SaveSlot.new("1"),
	SaveSlot.new("2")
	]


func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://saves"):
		DirAccess.make_dir_absolute("user://saves")


func new_game(slot: int, save_name: String) -> void:
	var game := save_slots[slot]
	game.slot_name = save_name


func load_game() -> void:
	var file = FileAccess.open("user://saves/save", FileAccess.READ)
	file.get_var()


func save_game() -> void:
	var dummy := {"a": 1, "b": 2}
	var file = FileAccess.open("user://saves/save", FileAccess.WRITE)
	file.store_var(dummy)
