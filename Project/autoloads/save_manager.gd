extends Node
## The Saves manager is a global singleton that helps manage saving and loading data.
## Also it helps with changing to scenes and then loading/saving data.

const default_path := "user://saves/"

var save_slots: Array[SaveSlot] = []
var current_slot: SaveSlot = null
var i = 0


func _ready() -> void:
	if not DirAccess.dir_exists_absolute(default_path):
		DirAccess.make_dir_absolute(default_path)
	for dir in DirAccess.get_directories_at(default_path):
		save_slots.append(SaveSlot.new(dir))
	save_slots.sort_custom(SaveSlot.time_sort)
	if not save_slots.is_empty():
		current_slot = save_slots.front()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		save_game(str(i), current_slot)
		i+= 1
	if event.is_action_pressed("test_2"):
		load_game(save_slots[0])


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
func save_game(_name: String, slot: SaveSlot = current_slot) -> void:
	var save_data: Array
	var nodes = get_tree().get_nodes_in_group("Persistent")

	for node in nodes:
		if node.has_method("save"):
			save_data.append(node.call("save"))
		else:
			print("Persistent node '%s' does not have a save() function" % node.name)
	slot.new_save(_name, save_data)


## If there are no saves in a slot (see [member SaveSlot.saves]), returns [code]false[/code],
## otherwise loads the first save and returns [code]true[/code]
func load_game(slot: SaveSlot = current_slot) -> bool:
	var key_exclude := ["filename", "parent", "checkpoint", "position"]
	var nodes = get_tree().get_nodes_in_group("Persistent")
	if slot.saves.is_empty():
		printerr("There is no save in slot 's%'." % slot.name)
		return false
	if slot != current_slot:
		current_slot = slot

	var data = slot.saves[0].data
	for node in nodes:
		node.queue_free()

	for node_data in data:
		var new_object = load(node_data["filename"]).instantiate()
		if "camp" in node_data:
			new_object.global_position = array_to_vector2(node_data["camp"])
		if "position" in node_data:
			new_object.position = array_to_vector2(node_data["position"])
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


## This is a helper function to to help with storing vectors in [JSON].[br]
## Since [JSON] does not support vectors. (See [url=https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html]Saving in godot[/url]) 
func vector2_to_array(v: Vector2) -> Array:
	return [v.x, v.y]


## This is a helper function to to help with storing vectors in [JSON].[br]
## Since [JSON] does not support vectors. (See [url=https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html]Saving in godot[/url]) 
func array_to_vector2(a: Array) -> Vector2:
	if a.size() != 2:
		return Vector2.ZERO
	return Vector2(a[0], a[1])
