extends PanelContainer


@onready var item_list: ItemList = $ItemList

var player: Player = null

signal travel(_camp: Camp)


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
			if not player:
				return
			if player.camp == camp.camp_name:
				item_list.set_item_disabled(idx, true)


func _on_item_list_item_activated(index: int) -> void:
	var camp: Camp = item_list.get_item_metadata(index)
	if camp.camp_name == player.camp:
		return
	GameEnv.fade_in_out(0.5, "Travelling...")
	GameEnv.load_icon(true)
	await GameEnv.fade_step_in
	player.global_position = camp.global_position
	player.camp = camp.camp_name
	await GameEnv.fade_step_wait
	GameEnv.load_icon(false)
	travel.emit(camp)


func _on_visibility_changed() -> void:
	if visible:
		update_camps_list()
