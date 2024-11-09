extends Node


var save_slots: Array[SaveSlot] = []


func load_game() -> void:
	var file = FileAccess.open("user://saves/save", FileAccess.READ)
	str_to_var(file.get_as_text())


func save_game() -> void:
	var dummy := {"a": 1, "b": 2}
	var file = FileAccess.open("user://saves/save", FileAccess.WRITE)
	file.store_var(dummy)
