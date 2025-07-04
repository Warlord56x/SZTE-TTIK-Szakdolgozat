class_name SaveSlot

const MAX_SAVES := 5

var name: String = ""
var saves: Array[Save] = []
var at: int

var corruption: float = 0

var has_corrupt: bool = false
var all_corrupt: bool = false


func _init(_name: String) -> void:
	if not DirAccess.dir_exists_absolute(SaveManager.default_path + _name):
		DirAccess.make_dir_recursive_absolute(SaveManager.default_path + _name)
	name = _name
	saves = _get_saves()

	# Avoid relaying on the OS for modified time
	if saves.size() > 0:
		at = saves[0].at
	for save: Save in saves:
		if save.at > at:
			at = save.at


## Delete all the [Save]s in the [param saves] array and the folder.
## Removes itself from the [SaveManager]
func delete() -> void:
	for save: Save in saves:
		save.delete()
	DirAccess.remove_absolute(SaveManager.default_path + name)
	if self == SaveManager.current_slot:
		SaveManager.current_slot = null
	if self in SaveManager.save_slots:
		SaveManager.save_slots.erase(self)


## Gets the first [Save] in the [param saves] array.
func get_last_saved() -> Save:
	if saves.is_empty():
		return null
	return saves[0]


## Returns the time the directory was last modified.
func get_saved_at() -> String:
	var bias: int = Time.get_time_zone_from_system().bias * 60
	return Time.get_datetime_string_from_unix_time(at + bias, true)


## Makes a new save to the slots folder
func new_save(_name: String, _data: SaveFile) -> void:
	if saves.size() >= MAX_SAVES:
		saves.pop_back().delete()
	if _name.is_empty():
		var crypto := Crypto.new()
		var random_bytes := crypto.generate_random_bytes(MAX_SAVES)
		_name = str("NINSAVE_", random_bytes.hex_encode())
	if _name.get_extension() == "":
		_name += ".tres"
	var any = saves.filter(func(s: Save): return s.name == _name)
	if not any.is_empty():
		(any.front() as Save).save_data()
		return
	var save = Save.new(_name, self, _data)
	saves.push_front(save)
	at = save.at


## Saves list for this slot, in last edited order
func _get_saves() -> Array[Save]:
	if name.is_empty():
		return []

	var path := SaveManager.default_path + name
	var dir := DirAccess.open(path)

	var _saves: Array[Save] = []

	if dir:
		for file_name: String in dir.get_files():
			var naming := ".tres" in file_name and "NINSAVE" in file_name
			var default_name := file_name == "default_new_game.tres"
			if naming or default_name:
				var _save := Save.new(file_name, self)
				if _save.is_corrupt:
					has_corrupt = true
				_saves.append(_save)
		if has_corrupt:
			var _corruption := 0.0
			for save: Save in _saves:
				if save.is_corrupt:
					_corruption += 1.0
			all_corrupt = _corruption == len(_saves)
			corruption = _corruption / len(_saves) * 100.0
	else:
		print("An error occurred when trying to access the path.")

	_saves.sort_custom(time_sort)
	return _saves


func _to_string() -> String:
	var st := ""
	st += "Class: " + get_class() + "\n" 
	st += "Slot name: " + name + "\n"
	st += "Saves count: " + str(len(saves)) + "\n"
	st += "Has corrupt: " + str(has_corrupt) + "\n"
	st += "Corruption (%): " + str(corruption) + "%\n"
	st += "Saved at: " + get_saved_at() + "\n"
	return st


## Sort saves based on save date
static func time_sort(a, b) -> bool:
	return a.at > b.at
