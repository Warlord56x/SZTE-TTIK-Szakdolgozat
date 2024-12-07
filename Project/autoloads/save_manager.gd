extends Node
## The Saves manager is a global singleton that helps manage saving and loading data.
## Also it helps with changing to scenes and then loading/saving data.

const default_path := "user://saves/"

var save_slots: Array[SaveSlot] = []
var current_slot: SaveSlot = null

var version := "1"


func _ready() -> void:
	if not DirAccess.dir_exists_absolute(default_path):
		DirAccess.make_dir_absolute(default_path)
	for dir in DirAccess.get_directories_at(default_path):
		save_slots.append(SaveSlot.new(dir))
	save_slots.sort_custom(SaveSlot.time_sort)
	if not save_slots.is_empty():
		current_slot = save_slots.front()


## Checks if a slot with the name [param slot_name] already exists in [member SaveSlot.saves_array]
func slot_exists(slot_name: String) -> bool:
	return save_slots.any(func(s:SaveSlot):return s.name == slot_name)


## Makes a new save slot by the [param slot_name], if it already exists returns [code]false[/code],
## otherwise [code]true[/code].
func new_game(slot_name: String) -> bool:
	if slot_exists(slot_name):
		return false
	var _new_game := SaveSlot.new(slot_name)
	save_slots.append(_new_game)
	current_slot = _new_game
	return true


## Makes a new save in [param slot] and appends it to the front of the it's [member SaveSlot.saves_array]
func save_game(_name: String = "", slot: SaveSlot = current_slot) -> void:
	var save_file: SaveFile = SaveFile.new()
	var save_data: Array = save_file.data
	var nodes = get_tree().get_nodes_in_group("Persistent")

	for node in nodes:
		if node.has_method("save"):
			save_data.append(node.call("save"))
		else:
			print("Persistent node '%s' does not have a save() function" % node.name)
	slot.new_save(_name, save_file)


## If there are no saves in a slot (see [member SaveSlot.saves]), returns [code]false[/code],
## otherwise loads the first save and returns [code]true[/code]
func load_game(slot: SaveSlot = current_slot) -> bool:
	var key_exclude := ["filename", "parent", "checkpoint", "position", "inventory"]
	var nodes = get_tree().get_nodes_in_group("Persistent")

	if slot.saves.is_empty():
		printerr("There is no save in slot '%s'." % slot.name)
		return false
	if slot != current_slot:
		current_slot = slot

	var data = slot.saves[0].data.data
	for node in nodes:
		node.queue_free()

	for node_data in data:
		var new_object = load(node_data["filename"]).instantiate()
		if "camp" in node_data:
			var camps = get_tree().get_nodes_in_group("Camp")
			var camp_filtered = camps.filter(func(x): return x.camp_name == StringName(node_data["camp"]))
			var camp = null if camp_filtered.is_empty() else camp_filtered.front()

			if camp:
				new_object.global_position = camp.global_position
				new_object.camp = camp
		if "position" in node_data:
			new_object.position = node_data["position"]
		if "inventory" in node_data:
			var items: Array[Item] = []
			for item: Item in node_data["inventory"]:
				items.append(item)
			new_object.inventory.set_items(items)

		get_node(node_data["parent"]).add_child(new_object, true)
		new_object.add_to_group("Persistent")

		for key in node_data.keys():
			if key in key_exclude:
				continue
			new_object.set(key, node_data[key])
	return true


## Changes the current scene to [param scene], and loads a save from [param slot]
func change_to_loaded_game(scene: PackedScene, slot: SaveSlot = current_slot) -> void:
	get_tree().change_scene_to_packed(scene)
	await get_tree().physics_frame
	GameEnv.input_process = true
	load_game(slot)


## Changes the current scene of the scene tree to the given node, and saves it to a new slot.[br]
## Returns [code]false[/code] if the game fails to be saved and [code]true[/code] if it succeeds.[br]
func change_to_new_game(scene: PackedScene, slot_name: String) -> bool:
	get_tree().change_scene_to_packed(scene)
	await get_tree().physics_frame
	GameEnv.input_process = true

	if new_game(slot_name):
		save_game("default_new_game", current_slot)
		return true
	return false
