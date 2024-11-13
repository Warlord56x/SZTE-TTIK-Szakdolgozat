class_name Save

var slot: SaveSlot = null
var data: Array = []
var at: int = 0
var screen_shot: Texture2D = null
var name: String = ""

var _path: String = ""


func _init(_name: String, _slot: SaveSlot, _data: Array = []) -> void:
	name = _name
	if name.get_extension() == "":
		name += ".save"
	slot = _slot
	data = _data
	_path = SaveManager.default_path + "{0}/{1}".format([slot.name, name])
	if FileAccess.file_exists(_path):
		load_data()
	else:
		save_data()


func save_data() -> void:
	var file := FileAccess.open(_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(data, "\t"))
	file.close()
	at = FileAccess.get_modified_time(_path)


func load_data() -> void:
	var file := FileAccess.open(_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	at = FileAccess.get_modified_time(_path)


func get_saved_at() -> String:
	var bias: int = Time.get_time_zone_from_system().bias * 60
	return Time.get_datetime_string_from_unix_time(at + bias, true)
