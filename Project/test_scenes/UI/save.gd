class_name Save

var save_data: Dictionary = {}
var saved_at: int = 0
var screen_shot: Texture2D


func get_saved_at() -> String:
	var bias: int = Time.get_time_zone_from_system().bias * 60
	return Time.get_datetime_string_from_unix_time(saved_at + bias, true)
