class_name SaveSlot


var name: String = ""
var saves: Array[Save] = []
var at: int


func _init(_name: String) -> void:
	if not DirAccess.dir_exists_absolute(SaveManager.default_path + _name):
		DirAccess.make_dir_recursive_absolute(SaveManager.default_path + _name)
	at = FileAccess.get_modified_time(SaveManager.default_path + _name)
	name = _name
	saves = _get_saves()


## Makes a new save to the slots folder
func new_save(_name: String, _data: Array = []) -> void:
	if _name.get_extension() == "":
		_name += ".save"
	if saves.any(func(s: Save): return s.name == _name):
		return
	saves.push_front(Save.new(_name, self, _data))


## TODO: Loading of the save
func load_save() -> void:
	pass


## Saves list for this slot, in last edited order
func _get_saves() -> Array[Save]:
	if name.is_empty():
		return []

	var path := SaveManager.default_path + name
	var dir := DirAccess.open(path)

	var _saves: Array[Save] = []

	if dir:
		for file_name: String in dir.get_files():
			if ".save" in file_name:
				var _save := Save.new(file_name, self)
				_saves.append(_save)
	else:
		print("An error occurred when trying to access the path.")

	_saves.sort_custom(time_sort)
	return _saves


## Sort saves based on save date
static func time_sort(a, b) -> bool:
	return a.at > b.at
