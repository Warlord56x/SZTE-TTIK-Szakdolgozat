extends Node

const default_path := "user://saves/"

var save_slots: Array[SaveSlot] = [SaveSlot.new("0"), SaveSlot.new("1")]
var current_slot: SaveSlot = save_slots[0] if save_slots.size() > 0 else null
var i = 0


func _ready() -> void:
	if not DirAccess.dir_exists_absolute(default_path):
		DirAccess.make_dir_absolute(default_path)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		save_game(str(i))
		i+= 1


func new_game(slot_name: String) -> void:
	var _new_game := SaveSlot.new(slot_name)
	save_slots.append(_new_game)
	current_slot = _new_game


func save_game(_name: String) -> void:
	var save_data: Dictionary
	var nodes = get_tree().get_nodes_in_group("Persistent")
	for node in nodes:
		save_data.get_or_add("health", node.health)
		save_data.get_or_add("mana", node.mana)
		save_data.get_or_add("coin", node.coins)

		## TODO: the checkpoint should not be saved this way,
		## since next time this object could be null
		save_data.get_or_add("checkpoint", node.checkpoint)
	current_slot.new_save(_name, save_data)

## TODO: load
func load_game() -> void:
	pass
