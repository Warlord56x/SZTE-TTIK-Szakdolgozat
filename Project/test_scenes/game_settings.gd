class_name GameSettings

var fullscreen: Window.Mode = Window.MODE_WINDOWED
var vsync: DisplayServer.VSyncMode = DisplayServer.VSYNC_DISABLED
var master_volume: float = 0.5


func not_in(any: Variant, arr: Array) -> bool:
	for a in arr:
		if a == any:
			return false
	return true


func to_dict() -> Dictionary:
	var dict: Dictionary
	for prop in get_property_list():
		if not_in(prop.name.to_lower(), ["refcounted","script","built-in script"]):
			dict.get_or_add(prop.name, get(prop.name))
	return dict
