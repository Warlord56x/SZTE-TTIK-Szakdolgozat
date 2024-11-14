extends Node

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
	if save_slots.size() > 0:
		current_slot = save_slots.front()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		save_game(str(i), current_slot)
		i+= 1
	if event.is_action_pressed("test_2"):
		load_game(save_slots[0])


func new_game(slot_name: String) -> void:
	var _new_game := SaveSlot.new(slot_name)
	save_slots.append(_new_game)
	current_slot = _new_game


func vector2_to_array(v: Vector2) -> Array:
	return [v.x, v.y]


func array_to_vector2(a: Array) -> Vector2:
	if a.size() != 2:
		return Vector2.ZERO
	return Vector2(a[0], a[1])


func save_game(_name: String, slot: SaveSlot) -> void:
	var save_data: Array
	var nodes = get_tree().get_nodes_in_group("Persistent")

	for node in nodes:
		if node.has_method("save"):
			save_data.append(node.call("save"))
		else:
			print("Persistent node '%s' does not have a save() function" % node.name)
	slot.new_save(_name, save_data)


func change_to_loaded_game(scene: PackedScene, slot: SaveSlot = current_slot) -> void:
	GameEnv.fade_in_out(0.3)
	await GameEnv.fade_step1
	get_tree().change_scene_to_packed(scene)
	await GameEnv.fade_step2
	load_game(slot)


func change_to_new_game(scene: PackedScene) -> void:
	GameEnv.fade_in_out(0.3)
	await GameEnv.fade_step1
	get_tree().change_scene_to_packed(scene)
	await GameEnv.fade_step2
	new_game("default_slot")
	save_game("default_new_game", current_slot)


func load_game(slot: SaveSlot = current_slot) -> void:
	var key_exclude := ["filename", "parent", "checkpoint", "position"]
	var nodes = get_tree().get_nodes_in_group("Persistent")
	if slot.saves.is_empty():
		print("There is no save in slot 's%'." % slot.name)
		return

	var data = slot.saves[0].data
	for node in nodes:
		node.queue_free()

	for node_data in data:
		var new_object = load(node_data["filename"]).instantiate()
		if "checkpoint" in node_data:
			new_object.global_position = array_to_vector2(node_data["checkpoint"])
		if "position" in node_data:
			new_object.position = array_to_vector2(node_data["position"])
		get_node(node_data["parent"]).add_child(new_object, true)
		new_object.add_to_group("Persistent")

		for key in node_data.keys():
			if key in key_exclude:
				continue
			new_object.set(key, node_data[key])
