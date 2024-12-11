extends PanelContainer


@onready var item_list: ItemList = $ItemList

var player: Player = null


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	update_camps_list()


func update_camps_list() -> void:
	item_list.clear()
	var camps = get_tree().get_nodes_in_group("Camp")
	for camp: Camp in camps:
		if camp.active:
			var idx = item_list.add_item(camp.camp_name)
			item_list.set_item_metadata(idx, camp)


func _on_item_list_item_activated(index: int) -> void:
	var camp: Camp = item_list.get_item_metadata(index)
	player.global_position = camp.global_position


func _on_visibility_changed() -> void:
	if visible:
		update_camps_list()
