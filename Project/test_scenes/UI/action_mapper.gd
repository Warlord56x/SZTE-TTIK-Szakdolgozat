extends PanelContainer
class_name ActionMapper


@onready var actions: HBoxContainer = $Actions

var item: Item = null
var inventory: Inventory = null


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	for c: WheelItem in actions.get_children():
		c.gui_input.connect(input)
	if visible:
		actions.get_child(0).grab_focus()

	for slot: WheelItem in actions.get_children():
		slot.focus_exited.connect(lost_focus)


func lost_focus() -> void:
	await get_tree().create_timer(0.1).timeout
	for slot: WheelItem in actions.get_children():
		if slot.has_focus():
			return
	visible = false


func _on_visibility_changed() -> void:
	if visible:
		actions.get_child(0).grab_focus()
		for idx in actions.get_child_count():
			var child = actions.get_child(idx)
			child.item = inventory.get_item(idx)
			if child.item == item:
				child.item = null


func input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("click"):
		var focus_owner = get_window().gui_get_focus_owner()
		focus_owner.item = item
		var action_order: Array[Item] = []
		for order in actions.get_children():
			action_order.append(order.item)
		inventory.fill_action_slots(action_order)

	if event.is_action_released("ui_accept") or event.is_action_released("click"):
		await get_tree().create_timer(0.2).timeout
		visible = false
