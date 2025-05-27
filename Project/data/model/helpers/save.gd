class_name Save

var slot: SaveSlot = null
var data: SaveFile = null
var at: int = 0
var screen_shot: Texture2D = null
var name: String = ""

var _path: String = ""


func _init(_name: String, _slot: SaveSlot, _data: SaveFile = null) -> void:
	name = _name
	if name.get_extension() == "":
		name += ".tres"
	slot = _slot
	data = _data
	_path = SaveManager.default_path + "{0}/{1}".format([slot.name, name])
	if FileAccess.file_exists(_path):
		load_data()
	else:
		save_data()


func save_data(_data: SaveFile = data) -> void:
	var saved = ResourceSaver.save(_data, _path)
	at = _data.modified_at
	if saved != OK:
		printerr("Saving data has failed with error code: ", saved)
		return


func load_data() -> void:
	data = ResourceLoader.load(_path)
	at = data.modified_at


func get_saved_at() -> String:
	var bias: int = Time.get_time_zone_from_system().bias * 60
	return Time.get_datetime_string_from_unix_time(at + bias, true)


func rename(_name: String) -> void:
	name = _name
	if name.get_extension() == "":
		name += ".tres"
	DirAccess.rename_absolute(_path, SaveManager.default_path + "{0}/{1}".format([slot.name, name]))


func delete() -> void:
	DirAccess.remove_absolute(_path)


func _to_string() -> String:
	var _str = ""
	_str += "Class: " + get_class() + "\n"
	_str += "Save name: " + name + "\n"
	_str += "Slot name: " + slot.name + "\n"
	_str += "Save path: " + _path + "\n"
	_str += "Save data: " + str(data) + "\n"
	return _str
