class_name GameSettings

var fullscreen: Window.Mode = Window.MODE_WINDOWED
var vsync: DisplayServer.VSyncMode = DisplayServer.VSYNC_DISABLED
var master_volume: float = 0.5


func to_dict() -> Dictionary:
	var dict: Dictionary = {}
	# List of properties to exclude
	var exclude_list = ["refcounted", "script", "built-in script", "game_settings.gd"]

	# Loop through properties and add only if not in exclude list
	for prop in get_property_list():
		if prop.name.to_lower() not in exclude_list:
			dict[prop.name] = get(prop.name)
			
	return dict
