extends Control


@onready var categories: VBoxContainer = %Categories
@onready var menu: Menu = %Menu
@onready var item_status: ItemStatus = %ItemStatus
@onready var action_mapper: ActionMapper = %ActionMapper

var last_focus: Control = null


var inventory: Inventory:
	set(inv):
		inventory = inv
		for category: ItemCategoryList in categories.get_children():
			category.inventory = inventory
			if not category.item_activated.is_connected(display_mapper):
				category.item_activated.connect(display_mapper)
			if not category.item_selected.is_connected(update_item_display):
				category.item_selected.connect(update_item_display)
		action_mapper.inventory = inventory
		if not action_mapper.visibility_changed.is_connected(reset_focus):
			action_mapper.visibility_changed.connect(reset_focus)


func reset_focus() -> void:
	if not action_mapper.visible:
		last_focus.grab_focus()


func display_mapper(item: Item, pos: Vector2) -> void:
	if not item:
		return
	last_focus = get_window().gui_get_focus_owner()
	action_mapper.visible = false
	action_mapper.item = item
	action_mapper.position = pos
	action_mapper.position.y += 5
	action_mapper.visible = true


func update_item_display(item: Item) -> void:
	item_status.item = item
	if item:
		item_status.open()
	else:
		item_status.close()


func switch() -> void:
	if not menu.visible:
		if not GameEnv.input_process:
			return
		menu.open()
		update_categories()
		GameEnv.input_process = false
	else:
		close()


func update_categories() -> void:
	for category: ItemCategoryList in categories.get_children():
		category.update_items()


func close() -> void:
	if menu.visible:
		menu.close()
		item_status.close()
		action_mapper.visible = false
		GameEnv.input_process = true
		accept_event()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		switch()

	if event.is_action_pressed("menu"):
		close()
