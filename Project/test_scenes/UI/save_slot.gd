class_name SaveSlot

var name: String

var saves: Array[Save]


func _init(_name: String) -> void:
	DirAccess.make_dir_recursive_absolute("user://saves/" + _name)
	name = _name
	saves = _get_saves()


## Clears the slots folder
func clear():
	var path := "user://saves/{0}".format([name])
	var dir := DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		dir.remove(file_name)
		file_name = dir.get_next()


## Saves list for this slot, in last edited order
func _get_saves() -> Array[Save]:
	if name.is_empty():
		return []

	var path := "user://saves/{0}".format([name])
	var dir := DirAccess.open(path)

	var _saves: Array[Save] = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and ".save" in file_name:
				var file_path: String = path + "/" + file_name
				var save := Save.new()
				var file := FileAccess.open(file_path, FileAccess.READ)

				save.saved_at = FileAccess.get_modified_time(path + "/" + file_name)
				save.save_data = JSON.parse_string(file.get_as_text())
				_saves.append(save)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	_saves.sort_custom(time_sort)
	return _saves


## Sort saves based in save date
func time_sort(a: Save, b: Save) -> bool:
	return a.saved_at > b.saved_at
