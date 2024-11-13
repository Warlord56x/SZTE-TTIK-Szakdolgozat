extends Node

const default_path := "user://saves/"

var save_slots: Array[SaveSlot] = [SaveSlot.new("0"), SaveSlot.new("1")]
var current_slot: SaveSlot = save_slots[0] if save_slots.size() > 0 else null


func _ready() -> void:
	if not DirAccess.dir_exists_absolute(default_path):
		DirAccess.make_dir_absolute(default_path)


func new_game(slot_name: String) -> void:
	var _new_game := SaveSlot.new(slot_name)
	save_slots.append(_new_game)
	current_slot = _new_game


func load_game() -> void:
	var file = FileAccess.open("user://saves/save", FileAccess.READ)
	file.get_var()


func save_game() -> void:
	var dummy := {"a": 1, "b": 2}
	var file = FileAccess.open("user://saves/save", FileAccess.WRITE)
	file.store_var(dummy)
	current_slot.save()
	
